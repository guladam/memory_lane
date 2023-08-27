## Represents a single modifier value.
class_name Modifier
extends Node

## Emitted when a temporary modifier is expired.
signal expired

## The modifier value.
@export var value: float
## The duration of the modifier value, in turns.
## 0 or lower means it's a permanent modifier.
@onready var duration := 0

## Called when setting up a temporary modifier.
## [param turns] is the time before the modifier expires, in turns.
func remove_after(turns: int) -> void:
	duration = turns
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)


## Called when the enemy turn has ended. For temporary modifiers
## that's when their duration gets decremented.
func _on_enemy_turn_ended() -> void:
	if duration <= 0:
		return
	
	duration -= 1
	if duration <= 0:
		expired.emit(value)
