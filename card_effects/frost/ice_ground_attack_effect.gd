## [EffectCode] for firing an ice attack at the first ground [Enemy].
extends EffectCode

var frost_projectile := preload("res://weapons/frost_attack_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single ice bolt attack.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var target_pos: Vector2 = enemy.global_position - Vector2(0, enemy.get_center_y_offset())
	Events.projectile_spawn_requested.emit(target_pos, frost_projectile)
