## [EffectCode] for adding fuel to everyone at once.
extends EffectCode

var fuel_status := preload("res://status_effects/fuel.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## This effect adds fuel to everyone on board.
func apply_effect() -> void:
	for target in effect.targets:
		if not target is Enemy and not target is Player:
			continue
		
		target.status_effects.add_new_status(fuel_status)
