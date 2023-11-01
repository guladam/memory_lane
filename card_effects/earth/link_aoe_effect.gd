## [EffectCode] for applying one link at multiple [Enemy] units.
extends EffectCode

var link_status := preload("res://status_effects/link.tres")
var link_vfx := preload("res://weapons/link_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effect applies link.
func apply_effect() -> void:
	if effect.targets.is_empty():
		return
	
	var enemy: Enemy
	for target in effect.targets:
		enemy = target as Enemy
		if not enemy:
			continue
			
		enemy.status_effects.add_new_status(link_status)
		var new_vfx := link_vfx.instantiate()
		new_vfx.global_position = enemy.global_position
		enemy.get_tree().root.add_child(new_vfx)
