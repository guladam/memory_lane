## [EffectCode] for firing a fire bolt at the first ground [Enemy].
## Deals 1 dmg + 2 if the [Enemy] has ignite.
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")
var ignite_status := preload("res://status_effects/ignited_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single fire bolt.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	var bonus_dmg := 1 if enemy.status_effects.has_status(ignite_status) else 0
	Events.player_damage_modifier_requested.emit(bonus_dmg, 1)
	Events.projectile_spawn_requested.emit(target_pos, fire_bolt_projectile)
