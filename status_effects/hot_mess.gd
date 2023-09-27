## A status effect which applies two ignite,
## to a random [Enemy], when a Mismatch happens.
extends Status

var ignite_status := preload("res://status_effects/ignited_2_data.tres")
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
		print("request 2 random ignite")
		Events.add_status_to_random_enemy_requested.emit(ignite_status.duplicate())
