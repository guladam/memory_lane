extends CanvasLayer


@onready var card_pile_panel: CenterContainer = $CardPilePanel


func _ready() -> void:
	Events.card_pile_panel_requested.connect(_on_card_pile_panel_requested)
	

func _on_card_pile_panel_requested(title: String, cards: Array[CardData]): 
		card_pile_panel.show_panel(title, cards)
