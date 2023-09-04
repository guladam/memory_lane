## Base class representing all Melee Weapons.
## These are used by the melee [Enemy] units.
class_name MeleeWeapon
extends Weapon


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $Visuals/HitBox

var already_hit := false


## This method is used for performing an attack with the weapon.
func use_weapon() -> void:
	already_hit = false
	animation_player.play("use")
	await animation_player.animation_finished


## Called when the [HitBox] collides with a [HurtBox].
## This is used to make sure that the weapon only hits once per attack.
func _on_hit_box_area_entered(hurt_box: HurtBox) -> void:
	if not hurt_box or already_hit:
		return

	already_hit = true
