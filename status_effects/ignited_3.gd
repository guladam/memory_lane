extends Status


func apply_status(target: Node) -> void:
	assert(target.has_method("take_damage"), "Ignite target cannot take damage!")
	super.apply_status(target)
	await target.take_damage(1)
	status_applied.emit()
