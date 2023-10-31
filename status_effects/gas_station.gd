## A status effect which applies 1 fuel,
## to a random [Enemy].
extends Status

var fuel_status := preload("res://status_effects/fuel.tres")

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(_target: Node) -> void:
	if duration > 0:
		print("request 1 random fuel")
		Events.add_status_to_random_enemy_requested.emit(fuel_status.duplicate())
	status_applied.emit()
