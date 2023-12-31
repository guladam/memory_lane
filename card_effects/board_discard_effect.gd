## [EffectCode] for discarding the current hand on the [Board].
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effects discards the whole hand.
func apply_effect() -> void:
	var board = effect.targets[0] as Board
	if not board:
		return
	
	await board.discard_board()
