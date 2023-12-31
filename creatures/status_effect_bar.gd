## A collection of [Status] visuals under creatures.
class_name StatusEffectsBar
extends GridContainer


@onready var status_effect_ui := preload("res://creatures/status_effect.tscn")


## Adds a new visual for [Status].
## [param status] is the data needed.
func add_status(status: Status) -> void:
	var new_status = status_effect_ui.instantiate()
	add_child(new_status)
	new_status.setup(status)


## Updates all status effect for the creature.
## This should be called once every turn.
func update_all_status_effects(status_effects: Array) -> void:
	for i in range(get_child_count()):
		if i < status_effects.size():
			get_child(i).update(status_effects[i])


## Removes all status effects present.
func clear() -> void:
	for c in get_children():
		c.queue_free()
