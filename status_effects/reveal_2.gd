## A status effect which reveals 2 [Card]s,
## every turn.
extends Status


## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	Events.board_reveal_requested.emit(2)
	target.create_status_highlight(Status.ICONS[self.data.icon])
	status_applied.emit()
	super.apply_status(target)
