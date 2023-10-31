## A status effect which doubles all ignite duration on target.
extends Status

## This overrides the virtual method [method Status.apply_status].
## [param target] is the receiving unit.
func apply_status(_target: Node) -> void:
	# We do nothing because we need to handle the doubling effect
	# By checking in every other card / status effect.
	status_applied.emit()
