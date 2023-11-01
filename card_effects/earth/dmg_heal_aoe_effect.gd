## [EffectCode] for firing a small earth attack for multiple [Enemy] units.
## It also heals the [Player] for 1.
extends EffectCode

var earth_aoe_vfx := preload("res://weapons/earth_aoe_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a small earth attack over the first flying enemy
## and heals the player.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	
	var tree: SceneTree = effect.targets[0].get_tree()
	var player: Player = tree.get_first_node_in_group("player") as Player
	if player:
		player.heal(1)

	var enemy: Enemy
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
		
		var new_vfx := earth_aoe_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		tree.root.add_child(new_vfx)
		enemy.take_damage(1)
		
