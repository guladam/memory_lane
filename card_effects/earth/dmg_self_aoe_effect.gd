## [EffectCode] for damages multiple [Enemy] units and the [Player] for 2.
extends EffectCode

var dmg_self_vfx := preload("res://weapons/dmg_self_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return

	var tree: SceneTree = effect.targets[0].get_tree()
	var player: Player = tree.get_first_node_in_group("player") as Player
	if player:
		var new_dmg_self_vfx := dmg_self_vfx.instantiate()
		new_dmg_self_vfx.global_position = player.global_position
		tree.root.add_child(new_dmg_self_vfx)
		player.take_damage(2)
	
	var enemy: Enemy
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
			
		var new_dmg_self_vfx2 := dmg_self_vfx.instantiate()
		new_dmg_self_vfx2.global_position = enemy.global_position
		tree.root.add_child(new_dmg_self_vfx2)
		enemy.take_damage(2)
