## Component for damage hitboxes.
## Used by projectiles and melee attacks.
class_name Hitbox
extends Area2D


## This method returns the damage this hitbox creates.
func get_damage() -> int:
	return 1
