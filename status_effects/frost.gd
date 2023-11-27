## A status effect which ignites the receiving unit,
## applying -10% movementspeed per stack.
extends Status

var frost_owner: Enemy

## This overrides the virtual method [method Status.apply_status].
## [param target] is the receiving unit.
func apply_status(target: Node) -> void:
	var enemy := target as Enemy
	if not enemy:
		return
	
	frost_owner = enemy
	
	if duration >= 3:
		enemy.take_damage(duration)
		status_applied.emit()
		super.apply_status(target)
		remove()
	else:
		enemy.movement_modifiers.clear_modifiers()
		enemy.movement_modifiers.new_modifier(-0.1 * duration)
		status_applied.emit()
		super.apply_status(target)


func remove() -> void:
	if frost_owner:
		frost_owner.movement_modifiers.new_modifier(0.1 * duration)
	super.remove()
