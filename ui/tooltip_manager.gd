extends Control

const TOOLTIP_Y_OFFSET := -25

@onready var card_tooltip := preload("res://ui/card_tooltip.tscn")
var current_tooltip: Control


func _ready() -> void:
	Events.card_tooltip_requested.connect(_on_card_tooltip_requested)


func clear_tooltip() -> void:
	for t in get_children():
		t.fade_out()


func _on_card_tooltip_requested(card: CardData, card_gui: Control) -> void:
	current_tooltip = card_gui if current_tooltip != card_gui else null
	clear_tooltip()
	if not current_tooltip:
		return

	var rect := card_gui.get_global_rect()
	var tooltip = card_tooltip.instantiate()
	add_child(tooltip)
	tooltip.setup(card)
	
	await get_tree().process_frame
	
	tooltip.position = rect.position
	tooltip.position.x +=  rect.size.x / 2
	tooltip.position.x -= tooltip.size.x / 2
	tooltip.position.y -= tooltip.size.y / 2
	tooltip.position.y += TOOLTIP_Y_OFFSET
	tooltip.original_pos = tooltip.position
	tooltip.fade_in()
