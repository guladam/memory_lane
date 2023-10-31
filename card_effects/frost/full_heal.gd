## [EffectCode] for healing to full hp.
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.heal(99)
