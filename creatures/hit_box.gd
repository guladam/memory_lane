## Component for damage hitboxes.
## Used by projectiles and melee attacks.
class_name HitBox
extends Area2D


## This method returns the damage this hitbox creates.
func get_damage() -> int:
	return 1
