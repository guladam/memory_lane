## [EffectCode] for damages both a single [Enemy] and the [Player] for 2.
extends EffectCode

var dmg_self_vfx := preload("res://weapons/dmg_self_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	
	var enemy = effect.targets[0] as Enemy
	var tree: SceneTree = enemy.get_tree()
	
	var new_dmg_self_vfx := dmg_self_vfx.instantiate()
	new_dmg_self_vfx.global_position = enemy.global_position
	tree.root.add_child(new_dmg_self_vfx)
	enemy.take_damage(2)
	
	var player: Player = tree.get_first_node_in_group("player") as Player
	if player:
		var new_dmg_self_vfx2 := dmg_self_vfx.instantiate()
		new_dmg_self_vfx2.global_position = player.global_position
		tree.root.add_child(new_dmg_self_vfx2)
		player.take_damage(2)
