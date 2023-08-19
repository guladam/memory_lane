## Base class representing all Weapons.
## These are used by the [Enemy] units to attack the [Player].
class_name Weapon
extends Node2D

@export var attack_range: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $Visuals/HitBox

var already_hit := false


## This method is used for performing az attack with the weapon.
func use_weapon() -> void:
	already_hit = false
	animation_player.play("use")


func _on_hit_box_area_entered(hurt_box: HurtBox) -> void:
	if not hurt_box or already_hit:
		return

	already_hit = true
