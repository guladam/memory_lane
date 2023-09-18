## Base class representing all Ranged Weapons.
## These are used by the ranged [Enemy] units.
class_name RangedWeapon
extends Weapon


## The projectile this weapon fires.
@export var projectile: PackedScene
@export var animation_player: AnimationPlayer
@export var visuals: Node2D
@export var muzzle: Marker2D
## The target of the unit, in global coordinates.
var target := Vector2.ZERO


## This method is used for performing az attack with the weapon.
func use_weapon() -> void:
	if not animation_player or not visuals:
		return

	var old_rotation := visuals.rotation
	
	visuals.look_at(target)
	animation_player.play("use")
	await animation_player.animation_finished
	
	visuals.rotation = old_rotation


## This method is used to spawn a projectile when shooting the weapon.
## Can be called within animations for the weapon.
func spawn_projectile() -> void:
	if not projectile or not muzzle:
		return

	var new_projectile := projectile.instantiate()
	get_tree().root.add_child(new_projectile)
	new_projectile.global_position = muzzle.global_position
	new_projectile.launch(target)
