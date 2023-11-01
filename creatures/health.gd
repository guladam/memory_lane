## Class representing a creatures health
class_name Health
extends Node

## Emitted when the unit's health would be bigger
## than its max health.
signal over_healed
## Emitted when the unit's health has changed.
signal changed(new_health: int)
## Emitted when the unit's max health has changed.
signal max_health_changed(new_max_health: int)
## Emitted when health reaches zero.
signal reached_zero

## Maximum health of the unit. Gaining more maximum health
## updates the "regular" health as well.
@export var max_health: int :
	set(new_max_health):
		var delta := new_max_health - max_health
		max_health = max(0, new_max_health)
		max_health_changed.emit(max_health)
		
		if delta > 0:
			health += delta
		else:
			health += 0


## Current health of the creature.
var health: int : 
	set(new_health):
		if new_health > max_health:
			over_healed.emit()
		
		health = clamp(new_health, 0, max_health)
		changed.emit(health)
		
		if health <= 0:
			reached_zero.emit()
