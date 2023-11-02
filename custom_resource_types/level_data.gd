## A [Resource] for holding data regarding levels.
class_name LevelData
extends Resource


## This identifies when the [Player] can encounter this Level
## during a [Run]. Should be between 1 and [constant Game.LEVELS_PER_RUN]
## e.g. level_pool = 3 means that this is a *potential* third level in 
## every run.
@export var level_pool: int
## This contains when and which [Enemy] units will be spawned.
@export var spawn_table: Array[LevelSpawnData]
## Optional custom music track for the Level.
@export var music_track: AudioStream

## Returns the total number of [Enemy] units on this level.
## This can be used to check if the [Player] killed all enemies.
func get_number_of_enemies() -> int:
	return spawn_table.reduce(
		func(sum, spawn_data): return sum + spawn_data.enemies.size(),
		0
	)


## Returns the [LevelSpawnData] for a specific [param turn].
func get_spawn_data_for_turn(turn: int) -> LevelSpawnData:
	var that_turn: Array[LevelSpawnData] = \
		spawn_table.filter(func(spawn_data): return spawn_data.turn == turn)
	
	if that_turn.is_empty():
		return null
	
	return that_turn[0]
