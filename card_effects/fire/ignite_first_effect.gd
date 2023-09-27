## [EffectCode] for igniting the first [Enemy] unit.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_2_data.tres")
var ignite_vfx := preload("res://weapons/ignite_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect ignites the [Enemy] on board.
func apply_effect() -> void:
	var enemy := effect.targets[0] as Enemy
	if not enemy:
		return
		
	enemy.status_effects.add_new_status(ignite_status)
	var new_vfx := ignite_vfx.instantiate()
	new_vfx.global_position = enemy.global_position
	enemy.get_tree().root.add_child(new_vfx)
