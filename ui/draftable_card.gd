## A card which can be selected to draft into a [Deck].
extends TextureRect

## Emitted when the draftable card is selected.
signal selected(card: CardData)

var card: CardData


## Setting up the visuals based on the data.
## [param _card] is the [CardData] resource.
func setup(_card: CardData) -> void:
	card = _card
	texture = card.card_front


## Deselects the draftable card.
func deselect() -> void:
	print("deselected %s" % card.id)


## Selects the draftable card.
func select() -> void:
	print("selected %s" % card.id)


## Selects the draftable card when its clicked.
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		select()
		selected.emit(card)
