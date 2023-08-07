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
	draw_pile.setup(deck)
	board.spawn_cards(draw_pile.draw_cards(12))
	board.matched.connect(_on_board_matched)
	board.emptied.connect(_on_board_emptied)
	board.discarded.connect(_on_board_discarded)


## Called when a match is made on the board.
func _on_board_matched(card: CardData) -> void:
	discard_pile.cards.append(card)
	discard_pile.cards.append(card)

## Called when the board is emptied.
func _on_board_emptied() -> void:
	board.spawn_cards(draw_pile.draw_cards(12))


## Called when the board is discarded.
## [param cards] is an array of [CardData]
func _on_board_discarded(cards: Array) -> void:
	for card in cards:
		discard_pile.cards.append(card)
	
	board.spawn_cards(draw_pile.draw_cards(12))
