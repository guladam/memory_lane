## [EffectCode] for firing a small meteor above the first ground [Enemy].
## Deals 2 damage.
extends EffectCode

var ice_bolt_projectile := preload("res://weapons/ice_bolt_projectile_2dmg.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires an ice attack over the first ground enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	Events.projectile_spawn_requested.emit(target_pos, ice_bolt_projectile)
