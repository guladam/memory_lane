## [EffectCode] for shattering all [Enemy] units at once.
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var shatter_vfx := preload("res://weapons/shatter_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect shatters all enemies on board.
func apply_effect() -> void:
	var enemy: Enemy
	
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
		
		var current_frost: Status = enemy.status_effects.get_status(frost_status)
		if current_frost:
			enemy.take_damage(current_frost.duration)
			enemy.status_effects.remove_status(frost_status)
			var new_vfx := shatter_vfx.instantiate()
			new_vfx.global_position = enemy.global_position
			enemy.get_tree().root.add_child(new_vfx)
