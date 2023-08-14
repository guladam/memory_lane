## Current draw pile of the player.
## It is a subset of the player's current [Deck].
class_name DrawPile
extends Node2D

## Emitted when the deck is reshuffled because there
## were no more cards left in the draw pile.
signal reshuffled(cards_still_needed: int)

## Label displaying the number of [Card]s in the draw pile.
@onready var cards_label: Label = $CardsLabel
## The draw pile is dependent of the [Deck] to work properly.
var deck: Deck
## Available [CardData] in the draw pile.
var cards: Array[CardData]


func _ready() -> void:
	Events.card_draw_started.connect(_on_card_draw_started)
	

## This function is for injecting the [Deck] dependency.
func setup(_deck: Deck) -> void:
	deck = _deck
	cards = deck.cards.duplicate(true)
	_update_label(cards.size())


## Draws [param n] cards from the draw pile.
## [param n] should always be even because we need to make sure
## the player can match all the cards on the [Board].
func draw_cards(n: int) -> Array[CardData]:
	assert(n % 2 == 0, "the draw pile shouldn't ever be odd!")
	
	var drawn_cards: Array[CardData] = []
	while drawn_cards.size() < n:
		var card = cards.pop_back()
		if not card:
			return drawn_cards
		
		for card2 in cards:
			if card2.is_matching(card):
				cards.erase(card2)
				break
		
		drawn_cards.append(card)
		drawn_cards.append(card)
	
	drawn_cards.shuffle()
	return drawn_cards


## Reshuffles the draw pile. Emits the [signal reshuffled] signal.
func reshuffle(cards_already_drawn: Array[CardData], cards_to_draw: int) -> void:
	deck.shuffle()
	cards.clear()
	cards = deck.cards.duplicate(true)
	
	for card in cards_already_drawn:
		cards.erase(card)
	
	_update_label(cards.size())
	reshuffled.emit(cards_to_draw - cards_already_drawn.size())


## Updates the label counter.
func _update_label(number: int) -> void:
	cards_label.text = str(number)


## Decrements the label counter by one.
func _on_card_draw_started(_card: Card) -> void:
	var new_number: int = max(0, int(cards_label.text) - 1)
	_update_label(new_number)
