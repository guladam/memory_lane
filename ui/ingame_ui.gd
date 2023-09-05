## This class holds and manages all UI (HUD) elements in a [Level].
extends CanvasLayer


@onready var card_pile_panel: CenterContainer = $CardPilePanel
var current_character: Character


func _ready() -> void:
	Events.card_pile_panel_requested.connect(_on_card_pile_panel_requested)


func setup(character: Character) -> void:
	current_character = character


## Displays a card pile panel when requested.
## [param title] is the title of the requested panel (e.g. Draw Pile),
## [param cards] is the array of [CardData] to be displayed.
func _on_card_pile_panel_requested(title: String, cards: Array[CardData]): 
		card_pile_panel.show_panel(title, cards, current_character)
