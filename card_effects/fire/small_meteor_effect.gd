## [EffectCode] for firing a small meteor above the first air [Enemy].
## Applies 1 dmg and 1 ignite
extends EffectCode

var fire_bolt_ignite_projectile := preload("res://weapons/fire_bolt_ignite_projectile.tscn")
var ignite_status := preload("res://status_effects/ignited_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a meteor over the first flying enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	
	Events.projectile_spawn_requested.emit(to, fire_bolt_ignite_projectile, from)
	var new_ignite := ignite_status.duplicate(true)
	if enemy.status_effects.has_status_by_id("fuel"):
		new_ignite.duration *= 2
	enemy.status_effects.add_new_status(new_ignite)
