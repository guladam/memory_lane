## [EffectCode] for firing a meteor shower above all units.
## Deals 1 dmg + applies 1 ignite to EVERYONE
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_1_data.tres")
var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")
var enemy_fire_bolt_projectile := preload("res://weapons/enemy_fire_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a meteor over all enemies.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var player: Player = effect.targets[0] as Player
	var to: Vector2 = player.global_position
	var from: Vector2 = to + Vector2(0, -100)
	Events.projectile_spawn_requested.emit(to, enemy_fire_bolt_projectile, from)
	
	
	var new_ignite := ignite_status.duplicate(true)
	if player.status_effects.has_status_by_id("fuel"):
		new_ignite.duration *= 2
	player.status_effects.add_new_status(new_ignite)
	
	var enemy: Enemy
	for i in range(1, effect.targets.size()):
		enemy = effect.targets[i] as Enemy
		if not enemy:
			continue
		
		to = enemy.global_position
		from = to + Vector2(0, -100)
		Events.projectile_spawn_requested.emit(to, fire_bolt_projectile, from)
		
		new_ignite = ignite_status.duplicate(true)
		if enemy.status_effects.has_status_by_id("fuel"):
			new_ignite.duration *= 2
		enemy.status_effects.add_new_status(new_ignite)
