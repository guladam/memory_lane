## UI for representing creature health.
class_name HealthBar
extends PanelContainer


@onready var bar := preload("res://creatures/hp_bar.tscn")
@onready var bars: HBoxContainer = $Bars

## Used for setting up the correct number of hp bars.
## This happens when a unit spawns into the world or when its
## max health changes.
func setup(max_health: int) -> void:
	var delta := max_health - bars.get_child_count()
	
	if delta == 0:
		return
	elif delta < 0:
		for i in range(abs(delta)):
			bars.get_child(-i).queue_free()
	else:
		for _i in range(delta):
			var new_bar = bar.instantiate()
			bars.add_child(new_bar)


## Updates the HealthBar according to the new health of the creature.
## Should be called when a units health changes.
func update_health(health: int) -> void:
	await get_tree().process_frame
	
	if health > bars.get_child_count():
		push_error("Health is bigger then the number of hp bars!")
		return
		
	for i in range(health):
		bars.get_child(i).color.a = 255
	for i in range(health, bars.get_child_count()):
		bars.get_child(i).color.a = 0
