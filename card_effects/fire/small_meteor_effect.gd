## [EffectCode] for firing a small meteor above the first air [Enemy].
extends EffectCode

var fire_bolt_projectile := preload("res://weapons/fire_bolt_projectile.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a single fire bolt.
func apply_effect() -> void:
	print("small meteor effect...")
	var enemy = effect.targets[0] as Enemy
	if not enemy:
		print("no enemy available")
		return
	
	await effect.player.play_spell_animation(Effect.TargetType.SELF)
	_spawn_meteor()
	await effect.player.play_spell_animation(Effect.TargetType.SELF, true)


func _spawn_meteor() -> void:
	var enemy = effect.targets[0] as Enemy
	
	var new_projectile := fire_bolt_projectile.instantiate()
	enemy.get_tree().root.add_child(new_projectile)
	new_projectile.global_position = enemy.global_position + Vector2(0, -100)
	new_projectile.launch(enemy.global_position, effect.player.bonus_damage.get_modifier())
