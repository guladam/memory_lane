## [EffectCode] for firing a small ice lance above the first air [Enemy].
extends EffectCode

var frost_projectile := preload("res://weapons/frost_attack_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a small ice lance over the first flying enemy.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("no enemy available")
		return
	
	var enemy = effect.targets[0] as Enemy
	var to: Vector2 = enemy.global_position
	var from: Vector2 = to + Vector2(0, -100)
	Events.projectile_spawn_requested.emit(to, frost_projectile, from)
