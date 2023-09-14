## [EffectCode] for igniting all [Enemy] units at once.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_3_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect ignites all enemies on board.
func apply_effect() -> void:
	var enemy: Enemy
	
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
		
		enemy.status_effects.add_new_status(ignite_status)
