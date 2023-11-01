## [EffectCode] for damages an [Enemy] unit for 4
## but heals all other units to max hp.
extends EffectCode

var earth_aoe_vfx := preload("res://weapons/earth_aoe_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a small earth attack over the first flying enemy
## and heals the player.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	

	var chosen_enemy: Enemy = effect.targets.pick_random() as Enemy
	var new_vfx := earth_aoe_vfx.instantiate()
	new_vfx.global_position = chosen_enemy.global_position
	chosen_enemy.get_tree().root.add_child(new_vfx)
	chosen_enemy.take_damage(4)
	
	var enemy: Enemy
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy or enemy == chosen_enemy:
			continue
		
		enemy.heal(99)
