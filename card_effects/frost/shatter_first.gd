## [EffectCode] for applying one shatter at the first [Enemy].
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var shatter_vfx := preload("res://weapons/shatter_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect applies 1 shatter.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var current_frost: Status = enemy.status_effects.get_status(frost_status)
	if current_frost:
		enemy.take_damage(current_frost.duration)
		enemy.status_effects.remove_status(frost_status)
		var new_vfx := shatter_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(new_vfx)
