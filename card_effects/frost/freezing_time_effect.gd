## [EffectCode] for applying 3 frost to all [Enemy] units.
## Then, the player skips the next turn.
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")
var skip_status := preload("res://status_effects/freezing_time.tres")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect fires a meteor over all enemies.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var player: Player = effect.targets[0] as Player
	player.status_effects.add_new_status(skip_status, 0)
	
	var enemy: Enemy
	var new_frost = frost_status.duplicate(true)
	new_frost.duration = 3
	for i in range(1, effect.targets.size()):
		enemy = effect.targets[i] as Enemy
		if not enemy:
			continue
			
		enemy.status_effects.add_new_status(new_frost)
		var new_vfx := frost_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(new_vfx)
