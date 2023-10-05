## Fire [Character]'s starting status.
## Has a 20% chance of applying 1 ignite to a random [Enemy] every turn.
extends Status

var ignite_status := preload("res://status_effects/ignited_1_data.tres")
var ignite_vfx := preload("res://weapons/ignite_vfx.tscn")

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(_target: Node) -> void:
	var roll := randf()
	print("rolled: %s for the fire starter" % roll)
#	if roll <= 0.3:
	if false:
		Events.add_status_to_random_enemy_requested.emit(ignite_status.duplicate(), ignite_vfx)
		print("rolled 1 random ignite")
		
	status_applied.emit()
	super.apply_status(_target)
