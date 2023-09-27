## Represents level spawn data, i.e. an [Array] of [Enemy]
## units for a specific turn.
class_name LevelSpawnData
extends Resource

@export var turn: int
@export var enemies: Array[PackedScene]
