## A playable level.
class_name Level
extends Node2D


## Current [Deck] of the player.
@export var deck: Deck
@onready var board: Board = $Board
@onready var draw_pile: DrawPile = $DrawPile
@onready var discard_pile: DiscardPile = $DiscardPile

## Turn counter. Used for spawning in [Enemy]
## units at specific turns.
var turn := 0
## A queue for drawing a new set of [Card]s.
## This can only happen after a new player turn begins.
var draw_queue := []

func _ready() -> void:
	randomize()
	deck.shuffle()
	discard_pile.setup(deck)
	draw_pile.setup(deck)
	
	Events.draw_pile_reshuffled.connect(_on_draw_pile_reshuffled)
	Events.board_emptied.connect(_on_board_emptied)
	Events.player_turn_started.connect(_draw_new_hand)
	Events.enemy_turn_ended.connect(_new_turn)
	Events.game_over.connect(func(): print("game over!"))
	
	board.setup(draw_pile.global_position, discard_pile.global_position)
	board.spawn_cards(draw_pile.draw_cards(12))


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
func _on_draw_pile_reshuffled(remaining_cards: int) -> void:
	await get_tree().create_timer(0.2).timeout
	await discard_pile.empty(draw_pile.global_position)
	await get_tree().create_timer(0.4).timeout
	board.spawn_cards(draw_pile.draw_cards(remaining_cards))


## Called when all enemies completed their actions.
func _new_turn(): 
	self.turn += 1
	print("turn %s begins." % turn)
