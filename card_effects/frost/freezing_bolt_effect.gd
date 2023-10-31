## [EffectCode] for firing a small meteor above the first air [Enemy].
## Deals 2 damage.
extends EffectCode

var ice_bolt_projectile := preload("res://weapons/ice_bolt_projectile_2dmg.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires an ice attack over the first flying enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	
	Events.projectile_spawn_requested.emit(to, ice_bolt_projectile, from)
