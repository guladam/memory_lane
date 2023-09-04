## A [Resource] for holding data regarding levels.
class_name LevelData
extends Resource


## This identifies when the [Player] can encounter this Level
## during a [Run]. Should be between 1 and [constant Game.LEVELS_PER_RUN]
## e.g. level_pool = 3 means that this is a *potential* third level in 
## every run.
@export var level_pool: int
## This contains when and which [Enemy] units will be spawned.
## key (int): turn to spawn the unit(s)
## value (array): array of [Enemy] units to spawn on that particular turn.
@export var spawn_table: Dictionary = {
	1: [],
	2: [],
	3: [],
	4: [],
	5: []
}


## Returns the total number of [Enemy] units on this level.
## This can be used to check if the [Player] killed all enemies.
func get_number_of_enemies() -> int:
	return spawn_table.values().reduce(
		func(sum, array): return sum + array.size(),
		0
	)
