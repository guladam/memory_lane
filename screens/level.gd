## A playable level.
class_name Level
extends Node2D

## Data of the current [Run].
@export var run: Run
## [LevelData] resource of the current Level.
@export var level_data: LevelData
## [GameState] dependency.
@export var game_state: GameState

@onready var board: Board = $Board
@onready var draw_pile: DrawPile = $DrawPile
@onready var discard_pile: DiscardPile = $DiscardPile
@onready var player: Player = $Creatures/Player
@onready var enemy_manager: EnemyManager = $Creatures/EnemyManager
@onready var ingame_ui: CanvasLayer = $IngameUI

## Turn counter. Used for spawning in [Enemy]
## units at specific turns.
var turn := 1
## Total number of enemies killed while playing this level.
## This is used to check for a win state.
var enemies_killed := 0
## A queue for drawing a new set of [Card]s.
## This can only happen after a new player turn begins.
var draw_queue := []

func _ready() -> void:
	randomize()
	discard_pile.setup(run.deck)
	draw_pile.setup(run.deck)
	enemy_manager.setup(player.get_ranged_target_position())
	ingame_ui.setup(run.character)
	
	Events.draw_pile_reshuffled.connect(_on_draw_pile_reshuffled)
	Events.board_emptied.connect(_on_board_emptied)
	Events.player_turn_started.connect(_draw_new_hand)
	Events.enemy_died.connect(_on_enemy_died)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	board.setup(draw_pile.global_position, discard_pile.global_position, run.character)
	board.spawn_cards(draw_pile.draw_cards(12))
	game_state.reset()
	enemy_manager.spawn_enemies_for_turn(turn, level_data)
	player.set_eye_color(run.character.color)


## Called when the board is emptied.
## We queue a new hand of [Card]s which will be drawn when it's
## the [Player]'s turn.
func _on_board_emptied() -> void:
	draw_queue.append(12)


## Draws a new set of [Card]s for the board, based on the draw_queue.
## If the queue is empty, this method does nothing.
func _draw_new_hand() -> void:
	var cards_needed = draw_queue.pop_back()
	
	if not cards_needed:
		return
		
	var cards := draw_pile.draw_cards(cards_needed)
	await board.spawn_cards(cards)
	if cards.size() < cards_needed:
		draw_pile.reshuffle(cards, cards_needed)


## Called when the draw pile gets reshuffled.
## First, it animates the cards reshuffling from the discard pile.
## Then, it draws the remaining cards.
## [param remaining_cards] is the number of cards that still need to be drawn.
func _on_draw_pile_reshuffled(remaining_cards: int) -> void:
	await get_tree().create_timer(0.2).timeout
	await discard_pile.empty(draw_pile.global_position)
	await get_tree().create_timer(0.4).timeout
	board.spawn_cards(draw_pile.draw_cards(remaining_cards))


## Submits a request to the show the [Deck] in the Card Pile panel.
func _on_deck_view_button_pressed() -> void:
	Events.card_pile_panel_requested.emit("Deck", run.deck.cards)


## Called when an [Enemy] unit dies.
## [param _enemy] is the unit that just died.
func _on_enemy_died(_enemy: Enemy) -> void:
	enemies_killed += 1
	if enemies_killed == level_data.get_number_of_enemies():
		await get_tree().create_timer(5.0).timeout
		Events.level_won.emit(level_data)
		print("level won! woo")


## Called when the enemy turn has ended.
func _on_enemy_turn_ended(): 
	self.turn += 1
	enemy_manager.spawn_enemies_for_turn(self.turn, level_data)
