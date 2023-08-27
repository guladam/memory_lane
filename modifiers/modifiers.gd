## This class represents one ore more modifier values connected to
## a base value. For example, an [Enemy]'s movement might be slowed
## by an Ice effect.
class_name Modifiers
extends Node


## If true, this is a %-based modifier.
## Otherwise, we just need to add the values together
@export var percent_based := true
## If true, this modifier is ignored.
var ignore := false
## Array holding the modifier instances.
var modifier_values := []
## The [Modifier] scene.
var modifier_scene := preload("res://modifiers/modifier.tscn")


func _ready() -> void:
	for c in get_children():
		modifier_values.append(c.value)

## Adds a new [Modifier] value to this collection.
## [param value] is the value you want to add. For % values, use floats
## between 0 and 1.
func new_modifier(value: float) -> Modifier:
	var m = modifier_scene.instantiate()
	m.value = value
	add_child(m)
	modifier_values.append(value)
	return m

## Adds a new temporary [Modifier] value to this collection.
## [param value] is the value you want to add. For % values, use floats
## between 0 and 1.
## [param duration] is the duration of this new value, in turns.
func new_temporary_modifier(value: float, duration: int) -> void:
	var m := new_modifier(value)
	m.expired.connect(func(expired_value): modifier_values.erase(expired_value))
	m.remove_after(duration)

## Clears all [Modifier] values.
func clear_modifiers() -> void:
	for c in get_children():
		remove_child(c)

## Returns the result of applying all present [Modifier]s.
func get_modifier() -> float:
	if ignore:
		return _get_base_value()
	
	return max(
		modifier_values.reduce(func(sum, n): return sum + n, _get_base_value()), 
		0.0
	)


## Returns the base value for these modifiers.
## Namely, 1.0 (100%) for percent-based values,
## and 0.0 (0) otherwise.
func _get_base_value() -> float:
	if percent_based:
		return 1.0
	
	return 0.0
