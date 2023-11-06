## Current draw pile of the player.
## It is a subset of the player's current [Deck].
class_name DrawPile
extends Node2D


## [GameState] dependency.
@export var game_state: GameState
## Label displaying the number of [Card]s in the draw pile.
@onready var cards_label: Label = %CardsLabel
## The draw pile is dependent of the [Deck] to work properly.
var deck: Deck
## Available [CardData] in the draw pile.
var cards: Array[CardData]


func _ready() -> void:
	Events.card_draw_started.connect(_on_card_draw_started)
	Events.card_reshuffle_anim_finished.connect(_on_card_reshuffle_anim_finished)
	

## This function is for injecting the [Deck] dependency.
func setup(_deck: Deck) -> void:
	deck = _deck
	cards = deck.cards.duplicate(true)
	cards.shuffle()
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
			drawn_cards.shuffle()
			return drawn_cards
		
		for card2 in cards:
			if card2.is_matching(card):
				cards.erase(card2)
				break
		
		drawn_cards.append(card)
		drawn_cards.append(card)
	
	drawn_cards.shuffle()
	return drawn_cards


## Reshuffles the draw pile. Emits the [signal Events.draw_pile_reshuffled] signal.
func reshuffle(cards_already_drawn: Array[CardData], cards_to_draw: int) -> void:
	cards.clear()
	cards = deck.cards.duplicate(true)
	cards.shuffle()
	
	for card in cards_already_drawn:
		cards.erase(card)
	
	Events.draw_pile_reshuffled.emit(cards_to_draw - cards_already_drawn.size())


## Updates the label counter.
func _update_label(number: int) -> void:
	cards_label.text = str(number)


## Decrements the label counter by one.
func _on_card_draw_started(_card: Card) -> void:
	var new_number: int = max(0, int(cards_label.text) - 1)
	_update_label(new_number)
	

## Increments the label counter by one.
func _on_card_reshuffle_anim_finished() -> void:
	var new_number: int = min(deck.cards.size(), int(cards_label.text) + 1)
	_update_label(new_number)


## Request to show the draw pile when it is clicked.
func _on_tap_detector_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if game_state.is_paused():
		return
	
	if event.is_action_pressed("tap"):
		Events.card_pile_panel_requested.emit("Draw Pile", cards)
