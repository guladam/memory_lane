## A visual representation of [Cards] in UI context.
## Used in non-gameplay screens: draw pile, card draft screen etc.
class_name CardView
extends Control


@onready var card_front: CardFront = %CardFront
@onready var number: Label = %Number

var card: CardData

## Sets up the card based on the [CardData].
## [param card_data] is the [CardData] resource.
## [param character] is the current [Character].
## [param amount] is the number of cards the holder has.
func setup(card_data: CardData, character: Character, amount: int) -> void:
	card = card_data
	card_front.setup(card_data, character)
	number.text = "×%s" % amount


## Toggles the tooltip when the player clicks on the card.
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Events.card_tooltip_requested.emit(self)
