## [EffectCode] for firing a meteor shower above all air [Enemy] units.
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a meteor over the all flying enemies.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy: Enemy
	for unit in effect.targets:
		enemy = unit as Enemy
		if not enemy:
			continue
		
		var to: Vector2 = enemy.global_position
		var from: Vector2 = to + Vector2(0, -100)
		Events.projectile_spawn_requested.emit(to, fire_bolt_projectile, from)
		await Events.projectile_hit
