## [EffectCode] for discarding the current hand on the [Board].
## It also adds 1 ignite to a random enemy.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_1_data.tres")
var ignite_vfx := preload("res://weapons/ignite_vfx.tscn")


## Overrides the virtual method of the [EffectCode] parent class.
## this effects discards the whole hand.
func apply_effect() -> void:
	var board = effect.targets[0] as Board
	if not board:
		return
	
	Events.add_status_to_random_enemy_requested.emit(ignite_status.duplicate(), ignite_vfx)
	await board.discard_board()
