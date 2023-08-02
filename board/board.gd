## Holds all the [Card]s currently visible to the player.
class_name Board
extends Node2D

## Emitted when two [Card]s are matched together correctly.
signal matched(card: CardData)
## Emitted when the player tried to match 2 different [Card]s.
signal mismatched
## Emitted when all pairs were found and the board is empty.
signal emptied

## [Card] scene used for spawning the cards in place.
@onready var card_scene := preload("res://cards/card.tscn")
## This array is tracking the currently flipped [Card](s).
@onready var flipped_cards := []
## Tracks the current number of [Card]s on the board.
@onready var cards_on_board := 0
## Interactable icon of the draw pile
@onready var draw_pile_icon: Sprite2D = $DrawPileIcon
## Interactable icon of the discard pile
@onready var discard_pile_icon: Sprite2D = $DiscardPileIcon
## Node holding the spawn position markers for the [Card]s.
@onready var card_markers: Node2D = $CardMarkers


## Spawns [Card]s in place based on an array of [CardData].
func spawn_cards(cards: Array[CardData]) -> void:
	for i in range(cards.size()):
		var new_card = card_scene.instantiate()
		var marker = card_markers.get_child(i)
		marker.add_child(new_card)
		
		new_card.card = cards[i]
		new_card.flipped.connect(_on_card_flipped)
		new_card.unflipped.connect(_on_card_unflipped)
		new_card.input_event.connect(_on_card_input_event.bind(new_card))
		new_card.animate_draw(draw_pile_icon.global_position, marker.global_position)
		await get_tree().create_timer(0.15).timeout
		
	cards_on_board = cards.size()


## Returns [code]true[/code] if there is a match made on the board.
func _is_match() -> bool:
	if flipped_cards.size() != 2:
		return false
	
	return flipped_cards[0].card.is_matching(flipped_cards[1].card)


## Checks the current flipped pair of [Card]s on the board.
func _check_pair() -> void:
	if _is_match():
		_on_match()
	else:
		_on_mismatch()


## Called when there is a matched pair of [Card]s on the board.
func _on_match() -> void:
	matched.emit(flipped_cards[0].card)
	flipped_cards[0].animate_match(flipped_cards[1].global_position, discard_pile_icon.global_position)
	await flipped_cards[1].animate_match(flipped_cards[0].global_position, discard_pile_icon.global_position)
	flipped_cards[0].queue_free()
	flipped_cards[1].queue_free()
	flipped_cards.clear()
	cards_on_board -= 2
	
	if cards_on_board <= 0:
		emptied.emit()


## Called when two different [Card]s are flipped over.
func _on_mismatch() -> void:
	mismatched.emit()
	await flipped_cards[0].unflip()
	await flipped_cards[0].unflip()


## Called when the [Card]s are clicked. The cards can't handle
## this event by themselved because we need to make sure that
## no more than 2 cards are flipped at any given time.
func _on_card_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, card: Card) -> void:
	if flipped_cards.size() == 2:
		return

	if event is InputEventMouseButton and event.is_pressed():
		if card.is_flipped:
			card.unflip()
		else:
			flipped_cards.append(card)
			card.flip()


## Called when a [Card] is flipped over.
func _on_card_flipped(_card: Card) -> void:
	if flipped_cards.size() == 2:
		_check_pair()


## Called when a [Card] is flipped back.
func _on_card_unflipped(card: Card) -> void:
	flipped_cards.erase(card)
