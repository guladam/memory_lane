extends Control

const TOOLTIP_Y_OFFSET := 25

@onready var status_tooltip := preload("res://ui/status_tooltip.tscn")
var current_tooltip: Node2D


func _ready() -> void:
	Events.status_tooltip_requested.connect(_on_status_tooltip_requested)


func clear_tooltip() -> void:
	for t in get_children():
		t.fade_out()


func _on_status_tooltip_requested(statuses: Array[StatusData], unit: Node2D) -> void:
	current_tooltip = unit if current_tooltip != unit else null
	clear_tooltip()
	
	if not current_tooltip or statuses.is_empty():
		return

	var tooltip = status_tooltip.instantiate()
	add_child(tooltip)
	tooltip.setup(statuses)
	
	await get_tree().process_frame
	
	var max_x: float = get_viewport_rect().size.x - tooltip.size.x
	tooltip.position = unit.global_position
	tooltip.position.x -= tooltip.size.x / 2
	tooltip.position.y += tooltip.size.y / 2
	tooltip.position.y += TOOLTIP_Y_OFFSET
	tooltip.position.x = clamp(tooltip.position.x, 0, max_x)
	tooltip.original_pos = tooltip.position
	tooltip.fade_in()
