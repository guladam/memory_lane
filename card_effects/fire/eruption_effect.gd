## [EffectCode] for dealing 1 damage to all ground [Enemy] units.
extends EffectCode

var ignite_kill_vfx := preload("res://weapons/ignite_kill_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## Deals 1 damage to all ground [Enemy] units.
func apply_effect() -> void:
	var enemy: Enemy
	
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue

		var kill_vfx := ignite_kill_vfx.instantiate()
		kill_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(kill_vfx)
		enemy.take_damage(1)
