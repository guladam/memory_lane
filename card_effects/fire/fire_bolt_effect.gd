## [EffectCode] for firing a fire bolt at the first ground [Enemy].
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single fire bolt.
func apply_effect() -> void:
	if effect.targets.is_empty():
		print("TODO fire it anyways??")
		print("no enemy available")
		return
	
	var enemy = effect.targets[0] as Enemy
	
	await effect.player.play_spell_animation(effect.target_type)
	effect.player.spawn_projectile(enemy.global_position, fire_bolt_projectile)
	await effect.player.play_spell_animation(effect.target_type, true)
