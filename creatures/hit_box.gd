@tool
## Component for damaging hitboxes.
## Used by projectiles and melee attacks.
class_name HitBox
extends Area2D

## enum for specifying the target of the HitBox.
enum Target {PLAYER, ENEMY}

## Base damage of this HitBox. This is without any modifiers.
@export var base_damage: int
## [enum Hitbox.Target] type for this HitBox.
@export var target: Target

@onready var damage := self.base_damage


func _ready() -> void:
	match target:
		Target.PLAYER:
			collision_layer = 4
			collision_mask = 2
		Target.ENEMY:
			collision_layer = 1
			collision_mask = 8


## This method returns the damage this HitBox creates.
func get_damage() -> int:
	return damage


## Adds [param bonus_damage] to the base damage of this HitBox.
func set_damage(bonus_damage: int) -> void:
	print("damage = base %s + %s bonus = %s" % [base_damage, bonus_damage, base_damage + bonus_damage])
	damage = base_damage + bonus_damage
