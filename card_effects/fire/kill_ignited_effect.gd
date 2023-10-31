## [EffectCode] for killing the first ignited [Enemy].
extends EffectCode

var ignited_status := preload("res://status_effects/ignited_2_data.tres")
var ignite_kill_vfx := preload("res://weapons/ignite_kill_vfx.tscn")


## Overrides the virtual method of the [EffectCode] parent class.
## Deals 99 damage to all ignited enemies.
func apply_effect() -> void:
	var enemy: Enemy
	
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
		if enemy.status_effects.has_status(ignited_status):
			var kill_vfx := ignite_kill_vfx.instantiate()
			kill_vfx.global_position = enemy.global_position
			enemy.get_tree().root.add_child(kill_vfx)
			enemy.take_damage(99)
			
	print("no valid target")
