## [EffectCode] for discarding the current hand on the [Board].
## It also heals the player for two HP.
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effects discards the whole hand and heals the player.
func apply_effect() -> void:
	var board = effect.targets[0] as Board
	if not board:
		return
	
	var player = board.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.heal(2)
	await board.discard_board()
	
