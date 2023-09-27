## [EffectCode] for healing to full hp while applying 2 self-burn.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_2_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.heal(99)
	player.status_effects.add_new_status(ignite_status)
