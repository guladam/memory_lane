## A status effect which skips the Player's turn.
extends Status


## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	Events.player_turn_ended.emit()
	target.create_status_highlight(Status.ICONS[self.data.icon])
	status_applied.emit()
	super.apply_status(target)
