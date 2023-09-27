## [EffectCode] for firing a fire bolt at the first air [Enemy].
## Deals 1 dmg + 1 if the [Enemy] has ignite.
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")
var ignite_status := preload("res://status_effects/ignited_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single fire bolt.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	var bonus_dmg := 1 if enemy.status_effects.has_status(ignite_status) else 0
	Events.player_damage_modifier_requested.emit(bonus_dmg, 1)
	Events.projectile_spawn_requested.emit(to, fire_bolt_projectile, from)
	await Events.projectile_hit
