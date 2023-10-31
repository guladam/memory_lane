## [EffectCode] for healing 1 hp and applying 1 frost to a random [Enemy].
extends EffectCode

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")

## Overrides the virtual method of the [EffectCode] parent class.
## this effects heals the [Player] for one hp and applies 1 frost to a random [Enemy].
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.heal(1)
	Events.add_status_to_random_enemy_requested.emit(frost_status, frost_vfx)
