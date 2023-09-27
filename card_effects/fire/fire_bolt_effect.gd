## [EffectCode] for firing a fire bolt at the first ground [Enemy].
## Deals 1 dmg + applies 1 ignite.
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")
var ignite_status := preload("res://status_effects/ignited_1_data.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single fire bolt.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("TODO fire it anyways??")
		print("no enemy available")
		return
	
	var enemy = effect.targets[0] as Enemy
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	Events.projectile_spawn_requested.emit(target_pos, fire_bolt_projectile)
	enemy.status_effects.add_new_status(ignite_status)
