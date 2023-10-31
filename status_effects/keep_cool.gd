## A status effect which discards a pair of [Card]s,
## to a random [Enemy], when a Mismatch happens.
extends Status

var first_turn := true

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(_target: Node) -> void:
	if first_turn:
		Events.cards_mismatched.connect(_on_cards_mismatched)
		first_turn = false
	
	status_applied.emit()


func _on_cards_mismatched() -> void:
	if duration > 0:
		print("request 1 random pair discard")
		await get_tree().create_timer(0.6).timeout
		Events.board_discard_requested.emit(1)
