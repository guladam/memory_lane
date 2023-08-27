@tool
## Component for damage hitboxes.
## Used by projectiles and melee attacks.
class_name HitBox
extends Area2D

enum Target {PLAYER, ENEMY}

@export var base_damage: int
@export var target: Target

@onready var damage := self.base_damage

# TODO make this run in editor
func _ready() -> void:
	match target:
		Target.PLAYER:
			collision_layer = 4
			collision_mask = 2
		Target.ENEMY:
			collision_layer = 1
			collision_mask = 8


## This method returns the damage this hitbox creates.
func get_damage() -> int:
	return damage


## Adds [param bonus_damage] to the base damage of this HitBox.
func set_damage(bonus_damage: int) -> void:
	print("damage = base %s + %s bonus = %s" % [base_damage, bonus_damage, base_damage + bonus_damage])
	damage = base_damage + bonus_damage
