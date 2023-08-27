class_name StatusEffectsBar
extends GridContainer


@onready var status_effect_ui := preload("res://creatures/status_effect.tscn")


func add_status(status: Status) -> void:
	var new_status = status_effect_ui.instantiate()
	add_child(new_status)
	new_status.setup(status)


func update_all_status_effects() -> void:
	for status in get_children():
		status.update()
