extends Control


@onready var card_tooltip := preload("res://ui/card_tooltip.tscn")
var current_card_view: CardView


func _ready() -> void:
	Events.card_tooltip_requested.connect(_on_card_tooltip_requested)


func clear_tooltip() -> void:
	for t in get_children():
		t.fade_out()


func _on_card_tooltip_requested(card_view: CardView) -> void:
	current_card_view = card_view if current_card_view != card_view else null
	clear_tooltip()
	if not current_card_view:
		return

	var rect := card_view.get_global_rect()
	var tooltip = card_tooltip.instantiate()
	add_child(tooltip)
	tooltip.position = rect.position
	tooltip.position.x +=  rect.size.x / 2
	tooltip.position.x -= tooltip.size.x / 2
	tooltip.setup(card_view.card)
	tooltip.fade_in()
