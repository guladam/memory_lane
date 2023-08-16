## A playable level.
class_name Level
extends Node2D


## Current [Deck] of the player.
@export var deck: Deck
@onready var board: Board = $Board
@onready var draw_pile: DrawPile = $DrawPile
@onready var discard_pile: DiscardPile = $DiscardPile

## Turn counter. Used for spawning in [Enemy]
## units at specific turns. TODO actually implement it
var turn := 0

func _ready() -> void:
	randomize()
	deck.shuffle()
	discard_pile.setup(deck)
	draw_pile.setup(deck)
	
	Events.draw_pile_reshuffled.connect(_on_draw_pile_reshuffled)
	Events.board_emptied.connect(_on_board_emptied)
	
	board.setup(draw_pile.global_position, discard_pile.global_position)
	board.spawn_cards(draw_pile.draw_cards(12))


## Called when the board is emptied.
func _on_board_emptied() -> void:
	var cards := draw_pile.draw_cards(12)
	print(cards)
	await board.spawn_cards(cards)
	if cards.size() < 12:
		draw_pile.reshuffle(cards, 12)


## Called when the draw pile gets reshuffled.
## First, it animates the cards reshuffling from the discard pile.
## Then, it draws the remaining cards.
func _on_draw_pile_reshuffled(remaining_cards: int) -> void:
	await get_tree().create_timer(0.2).timeout
	await discard_pile.empty(draw_pile.global_position)
	await get_tree().create_timer(0.4).timeout
	board.spawn_cards(draw_pile.draw_cards(remaining_cards))
