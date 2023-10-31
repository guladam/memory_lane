## [EffectCode] for firing a small meteor above the first ground [Enemy].
## Applies 1 dmg and 1 frost
extends EffectCode

var ice_bolt_projectile := preload("res://weapons/ice_bolt_projectile.tscn")
var frost_status := preload("res://status_effects/frost_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires an ice attack over the first ground enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	Events.projectile_spawn_requested.emit(target_pos, ice_bolt_projectile)
	enemy.status_effects.add_new_status(frost_status)
