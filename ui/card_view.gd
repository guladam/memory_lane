## A visual representation of [Cards] in UI context.
## Used in non-gameplay screens: draw pile, card draft screen etc.
extends Control

## Emitted when the tooltip of this card is shown.
signal tooltip_shown(card_view: Control)

@onready var card_front: CardFront = $CardFront
@onready var card_tooltip: Panel = $CardTooltip


## Sets up the card based on the [CardData].
## [param card_data] is the [CardData] resource.
## [param character] is the current [Character].
func setup(card_data: CardData, character: Character) -> void:
	card_front.setup(card_data, character)
	card_tooltip.setup(card_data)


## Toggles the tooltip when the player clicks on the card.
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		card_tooltip.toggle()


## Turns off the tooltip. This is used by classes managing these cards
## to ensure that only one tooltip is active at any given time.
func turn_off_tooltip() -> void:
	card_tooltip.fade_out_tooltip()


## Called when the tooltip of this card is shown.
func _on_card_tooltip_tooltip_shown() -> void:
	tooltip_shown.emit(self)
