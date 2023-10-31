## [EffectCode] for adding fuel to the first [Enemy] unit.
extends EffectCode

var fuel_status := preload("res://status_effects/fuel.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect adds fuel to the first [Enemy] on board.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	
	var enemy := effect.targets[0] as Enemy
	if not enemy:
		return
	
	enemy.status_effects.add_new_status(fuel_status)
