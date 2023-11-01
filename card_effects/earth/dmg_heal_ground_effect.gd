## [EffectCode] for firing an earth attack at the first ground [Enemy].
## It also heals the [Player] for 1.
extends EffectCode

var earth_projectile := preload("res://weapons/earth_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single earth bolt attack and heals the [Player] for 1.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var tree: SceneTree = enemy.get_tree()
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	Events.projectile_spawn_requested.emit(target_pos, earth_projectile)
	await tree.create_timer(0.3).timeout
	
	var player: Player = tree.get_first_node_in_group("player") as Player
	if player:
		player.heal(1)
