## A card which can be selected to draft into a [Deck].
extends Control

## Emitted when the draftable card is selected.
signal selected(card: CardData)

@onready var card_front: TextureRect = $CardFront
var card: CardData


## Setting up the visuals based on the data.
## [param _card] is the [CardData] resource.
## [param character] is the current [Character].
func setup(_card: CardData, character: Character) -> void:
	card = _card
	card_front.setup(_card, character)


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
