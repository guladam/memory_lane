class_name StatusEffects
extends Node

signal status_added(status: Status)

@export var status_effect_bar: StatusEffectsBar
@onready var status_scene := preload("res://status_effects/status.tscn")

## Applies all status effects on the owner of this Node.
func apply_status_effects() -> void:
	var status: Status
	for c in get_children():
		status = c as Status
		
		@warning_ignore("redundant_await")
		await status.apply_status(owner)
	
	if status_effect_bar:
		status_effect_bar.update_all_status_effects()


func add_new_status(status_data: StatusData) -> void:
	var new_status: Status = status_scene.instantiate()
	new_status.set_script(status_data.code)
	new_status.setup(status_data)
	add_child(new_status)
	status_added.emit(new_status)
	
	if status_effect_bar:
		status_effect_bar.add_status(new_status)
