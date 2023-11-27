## [EffectCode] for applying one shatter at the first [Enemy].
## This also transfers all of the [Enemy]'s frost to a different one.
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")
var shatter_vfx := preload("res://weapons/shatter_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect applies 1 shatter.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	var current_frost: Status = enemy.status_effects.get_status(frost_status)
	var duration: int
	
	if current_frost:
		duration = current_frost.duration
		enemy.take_damage(current_frost.duration)
		var new_vfx := shatter_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(new_vfx)
		await enemy.get_tree().create_timer(0.15).timeout
		
		var new_frost := frost_status.duplicate(true)
		new_frost.duration = duration
		Events.add_status_to_random_enemy_requested.emit(new_frost, frost_vfx)
