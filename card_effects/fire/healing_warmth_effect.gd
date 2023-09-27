## [EffectCode] for healing 1, or 2 if you have ignite.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_2_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	var bonus := 1 if player.status_effects.has_status(ignite_status) else 0
	player.heal(1 + bonus)
