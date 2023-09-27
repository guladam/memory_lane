## Manages all [Status] effects on a unit.
## This class relies on the unit having a [StatusEffectBar] ui.
class_name StatusEffects
extends Node

## Emitted when a [Status] gets added to unit.
signal status_added(status: Status)

## The GUI dependency for showing all the [Status] effects.
@export var status_effect_bar: StatusEffectsBar
@onready var status_scene := preload("res://status_effects/status.tscn")


## Applies all status effects on the owner of this Node.
func apply_status_effects() -> void:
	var status: Status
	for c in get_children():
		status = c as Status
		
		@warning_ignore("redundant_await")
		await status.apply_status(owner)
		
		if owner.health and owner.health.health <= 0:
			print("owner died while applying statuses")
			break
	
	if status_effect_bar:
		status_effect_bar.update_all_status_effects(get_children())


## Returns [code]true[/code] if the owner has a [param status].
func has_status(status: StatusData) -> bool:
	var found := false
	for s in get_children():
		if s.equals(status):
			found = true
	
	return found


## Returns the [param status] if it's present on the owner.
## Otherwise returns null.
func get_status(status: StatusData) -> Status:
	var that_status: Status = null
	
	for s in get_children():
		if s.equals(status):
			that_status = s
			break
	
	return that_status


## Returns all active [StatusData].
func get_all_status_data() -> Array[StatusData]:
	var data: Array[StatusData] = []
	for s in get_children():
		data.append(s.data)
	
	return data


## Refreshes all status effects on the GUI.
func _refresh_effect_bar() -> void:
	if not status_effect_bar:
		return
	
	status_effect_bar.clear()
	for s in get_children():
		status_effect_bar.add_status(s)


## Adds a new [Status] to the owner of this node.
## [param status_data] is the [StatusData] resource for the status effect.
func add_new_status(status_data: StatusData) -> void:
	if has_status(status_data):
		get_status(status_data).duration += status_data.duration
		status_effect_bar.update_all_status_effects(get_children())
		return
	
	var new_status: Status = status_scene.instantiate()
	new_status.set_script(status_data.code)
	new_status.setup(status_data)
	add_child(new_status)
	status_added.emit(new_status)
	
	if status_effect_bar:
		status_effect_bar.add_status(new_status)
