## Current draw pile of the player.
## It is a subset of the player's current [Deck].
class_name DrawPile
extends Node

## Emitted when the deck is reshuffled because there
## were no more cards left in the draw pile.
signal reshuffled

## The draw pile is dependent of the [Deck] to work properly.
var deck: Deck
## Available [CardData] in the draw pile.
var cards: Array[CardData]

## This function is for injecting the [Deck] dependency.
func setup(_deck: Deck) -> void:
	deck = _deck
	cards = deck.cards.duplicate(true)


## Draws [param n] cards from the draw pile.
## [param n] should always be even because we need to make sure
## the player can match all the cards on the [Board].
func draw_cards(n: int) -> Array[CardData]:
	assert(n % 2 == 0, "the draw pile shouldn't ever be odd!")
	
	var drawn_cards: Array[CardData] = []
	while drawn_cards.size() < n:
		var card = cards.pop_back()
		if not card:
			reshuffle(drawn_cards)
			continue
		
		for card2 in cards:
			if card2.is_matching(card):
				cards.erase(card2)
				break
		
		drawn_cards.append(card)
		drawn_cards.append(card)
	
	drawn_cards.shuffle()
	return drawn_cards


## Reshuffles the draw pile. Emits the [signal reshuffled] signal.
func reshuffle(cards_already_drawn: Array[CardData]) -> void:
	cards.clear()
	cards = deck.cards.duplicate(true)
	
	for card in cards_already_drawn:
		cards.erase(card)
	
	reshuffled.emit()
