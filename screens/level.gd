## A playable level.
class_name Level
extends Node2D


## Current [Deck] of the player.
@export var deck: Deck
@onready var board: Board = $Board
@onready var draw_pile: DrawPile = $DrawPile
@onready var discard_pile: DiscardPile = $DiscardPile


func _ready() -> void:
	randomize()
	deck.shuffle()
	discard_pile.setup(deck)
	draw_pile.setup(deck)
	
	draw_pile.reshuffled.connect(_on_board_reshuffled)
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


## Called when the board is discarded.
## [param cards] is an array of [CardData]
func _on_board_discarded(cards: Array) -> void:
	# If this is the last match, we can ignore it
	# because the board is emptied anyway
	if cards.size() <= 1:
		return
		
	_on_board_emptied()


func _on_board_reshuffled(remaining_cards: int) -> void:
	await get_tree().create_timer(0.2).timeout
	await discard_pile.empty(draw_pile.global_position)
	await get_tree().create_timer(0.4).timeout
	board.spawn_cards(draw_pile.draw_cards(remaining_cards))
