## [EffectCode] for applying one frost at the first [Enemy].
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect applies 1 frost.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	
	enemy.status_effects.add_new_status(frost_status)
	var new_vfx := frost_vfx.instantiate()
	new_vfx.global_position = enemy.global_position
	enemy.get_tree().root.add_child(new_vfx)
