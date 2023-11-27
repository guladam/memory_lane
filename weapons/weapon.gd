## Base class representing all Weapons.
## These are used by the [Enemy] units to attack the [Player].
class_name Weapon
extends Node

## the range of the weapon i.e. which grid the unit needs to
## reach to use the weapon.
@export var attack_range: int
## sound of using the weapon.
@export var sound: AudioStream

## This method is used for performing az attack with the weapon.
## Has to be implemented by different types of weapons.
func use_weapon() -> void:
	pass
