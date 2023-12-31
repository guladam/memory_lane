## [EffectCode] for healing 2 hp.
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effects heals the [Player] for 2 hp.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.heal(2)
