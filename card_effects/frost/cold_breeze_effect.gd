## [EffectCode] for firing a small meteor above the first air [Enemy].
## Applies 1 dmg and 1 ignite
extends EffectCode

var frost_projectile := preload("res://weapons/frost_attack_projectile.tscn")
var frost_status := preload("res://status_effects/frost_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires an ice attack over the first flying enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	var bonus_dmg := 1 if enemy.status_effects.has_status(frost_status) else 0
	Events.player_damage_modifier_requested.emit(bonus_dmg, 1)
	Events.projectile_spawn_requested.emit(to, frost_projectile, from)
