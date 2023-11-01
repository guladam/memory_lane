## [EffectCode] for firing a small earth attack above the first air [Enemy].
## It also heals the [Player] for 1.
extends EffectCode

var earth_projectile := preload("res://weapons/earth_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a small earth attack over the first flying enemy
## and heals the player.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	
	var enemy = effect.targets[0] as Enemy
	var tree: SceneTree = enemy.get_tree()
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	Events.projectile_spawn_requested.emit(to, earth_projectile, from)
	await tree.create_timer(0.3).timeout
	
	var player: Player = tree.get_first_node_in_group("player") as Player
	if player:
		player.heal(1)
