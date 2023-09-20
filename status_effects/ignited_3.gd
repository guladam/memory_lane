## A status effect which ignites the receiving unit,
## applying 1 damage per turn, for 3 turns.
extends Status


## This overrides the virtual method [method Status.apply_status].
## [param target] is the receiving unit.
func apply_status(target: Node) -> void:
	assert(target.has_method("take_damage"), "Ignite target cannot take damage!")
	await target.take_damage(1)
	status_applied.emit()
	super.apply_status(target)
