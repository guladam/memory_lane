## Represents a single modifier value.
class_name Modifier
extends Node

## Emitted when a temporary modifier is expired.
signal expired

## The modifier value.
@export var value: float
@onready var timer := $Timer

## Called when setting up a temporary modifier.
## [param duration] is the time before the modifier expires, in seconds.
func remove_after(duration: float) -> void:
	timer.wait_time = duration
	timer.start()


func _on_timer_timeout() -> void:
	emit_signal("expired", value)
	queue_free()
