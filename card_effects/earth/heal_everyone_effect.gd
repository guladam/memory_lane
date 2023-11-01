## [EffectCode] for healing everyone for 1.
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effect heals all units for 1.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var player: Player = effect.targets[0] as Player
	player.heal(1)
	
	var enemy: Enemy
	for i in range(1, effect.targets.size()):
		enemy = effect.targets[i] as Enemy
		if not enemy:
			continue
		
		enemy.heal(1)
