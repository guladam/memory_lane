## A status effect which heals the [Player]
## for 2 when a Mismatch happens.
extends Status

var first_turn := true
var player: Player

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	if first_turn:
		Events.cards_mismatched.connect(_on_cards_mismatched)
		first_turn = false
		player = target as Player
	
	status_applied.emit()


func _on_cards_mismatched() -> void:
	if duration > 0 and player:
		await get_tree().create_timer(0.25).timeout
		player.heal(2)
