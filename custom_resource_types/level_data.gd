class_name LevelData
extends Resource


@export var level_pool: int
@export var spawn_table: Dictionary = {
	1: [],
	2: [],
	3: [],
	4: [],
	5: []
}


func get_number_of_enemies() -> int:
	return spawn_table.values().reduce(
		func(sum, array): return sum + array.size(),
		0
	)
