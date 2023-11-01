## [EffectCode] for applying one link at the first [Enemy].
extends EffectCode

var link_status := preload("res://status_effects/link.tres")
var link_vfx := preload("res://weapons/link_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect applies link.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy = effect.targets[0] as Enemy
	
	enemy.status_effects.add_new_status(link_status)
	var new_vfx := link_vfx.instantiate()
	new_vfx.global_position = enemy.global_position
	enemy.get_tree().root.add_child(new_vfx)
