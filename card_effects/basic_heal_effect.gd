## [EffectCode] for healing 1 hp.
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effects heals the [Player] for one hp.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.heal(1)
