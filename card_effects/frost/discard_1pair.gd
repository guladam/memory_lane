## [EffectCode] for discarding the current 1 pair of [Card]s from the [Board].
extends EffectCode


## Overrides the virtual method of the [EffectCode] parent class.
## this effects discards a pair of [Card]s.
func apply_effect() -> void:
	var board = effect.targets[0] as Board
	if not board:
		return
	
	await board.discard_pair(1)
