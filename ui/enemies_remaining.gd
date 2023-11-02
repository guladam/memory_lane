## This is the UI to display how many enemies are left
## to defeat in the current level.
extends HBoxContainer

@onready var enemies_killed := 0
@onready var label: Label = $Label

var enemies: int
var level: LevelData : set = _set_level


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)


func _set_level(level_data: LevelData) -> void:
	level = level_data
	enemies = level.get_number_of_enemies()
	label.text = str(enemies)


## Called when an [Enemy] unit dies.
## [param _enemy] is the unit that just died.
func _on_enemy_died(_enemy: Enemy) -> void:
	enemies_killed += 1
	
	if not level:
		return
	
	label.text = str(enemies - enemies_killed)
