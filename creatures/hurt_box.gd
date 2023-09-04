@tool
## Component for taking damage.
## Used by units that have health and can take damage.
class_name HurtBox
extends Area2D

## enum for specifying the type of the HurtBox.
enum Type {PLAYER, ENEMY}
## [enum HurtBox.Type] of this HurtBox.
@export var is_type: Type


func _ready() -> void:
	match is_type:
		Type.PLAYER:
			collision_layer = 2
			collision_mask = 4
		Type.ENEMY:
			collision_layer = 8
			collision_mask = 1

## This class relies on its owner to have a "take_damage"
## method.
func _on_area_entered(hitbox: HitBox) -> void:
	if not hitbox:
		return

	if not owner.has_method("take_damage"):
		push_error("The owner has no take_damage method!")
		return

	owner.take_damage(hitbox.get_damage())
