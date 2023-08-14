## Current discard pile of the player.
## It is a subset of the player's current [Deck].
class_name DiscardPile
extends Node2D

## Label displaying the number of [Card]s in the discard pile.
@onready var cards_label: Label = $CardsLabel
## Scene for animating deck reshuffling.
@onready var reshuffle_card := preload("res://piles/card_reshuffle.tscn")
## Available [CardData] in the discard pile.
var cards: Array[CardData]
## The discard pile is dependent of the [Deck] to work properly.
var deck: Deck


func _ready() -> void:
	Events.card_discarded.connect(_on_card_discarded)
	Events.card_matched.connect(_on_card_discarded)
	

## This function is for injecting the [Deck] dependency.
func setup(_deck: Deck) -> void:
	deck = _deck


## Empties the discard pile. Used when the deck needs reshuffling.
func empty(draw_pile_position: Vector2) -> void:
	var tween = get_tree().create_tween()
	for i in range(cards.size()):
		tween.tween_callback(_animate_reshuffled_card.bind(draw_pile_position, self.global_position))
		tween.tween_callback(_update_label.bind(cards.size() - (i+1)))
		tween.tween_interval(0.15)

	await tween.finished
	cards.clear()


## Animates a card to reshuffle towards the draw pile.
func _animate_reshuffled_card(draw_pile_position: Vector2, discard_pile_position: Vector2) -> void:
	var card_anim: Path2D = reshuffle_card.instantiate()
	add_child(card_anim)
	card_anim.global_position = discard_pile_position
	var relative_end_point = Vector2(draw_pile_position.x - discard_pile_position.x, 0)
	card_anim.curve.set_point_position(1, relative_end_point)


## Updates the label counter.
func _update_label(number: int) -> void:
	cards_label.text = str(number)


## Increments the label counter by one.
func _on_card_discarded(_card: Card) -> void:
	cards.append(_card.card)
	var new_number: int = min(deck.cards.size(), cards.size())
	_update_label(new_number)
