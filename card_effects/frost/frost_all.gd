## [EffectCode] for applying 1 frost to all [Enemy] units at once.
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect applies 1 frost to all enemies on board.
func apply_effect() -> void:
	var enemy: Enemy
	
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
		
		enemy.status_effects.add_new_status(frost_status)
		var new_vfx := frost_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(new_vfx)
