## Fire [Character]'s starting status.
## Has a 20% chance of applying 1 ignite to a random [Enemy] every turn.
extends Status

var ignite_status := preload("res://status_effects/ignited_1_data.tres")
var ignite_vfx := preload("res://weapons/ignite_vfx.tscn")

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	var roll := randf()
	print("rolled: %s for the fire starter" % roll)
	if roll <= 0.2:
		var _icon_texture: Texture = Status.ICONS[self.data.icon]
		target.create_status_highlight(_icon_texture)
		
		if _should_target_player(target):
			target.status_effects.add_new_status(ignite_status)
		else:
			Events.add_status_to_random_enemy_requested.emit(ignite_status.duplicate(), ignite_vfx, _icon_texture)
		
		await get_tree().create_timer(1).timeout
	
	status_applied.emit()
	super.apply_status(target)


func _should_target_player(target: Player) -> bool:
	if not target or not target.status_effects.has_status_by_id("fuel"):
		return false
		
	var roll := randi() % 2
	return roll == 1
