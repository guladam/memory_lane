extends Weapon


@export var projectile: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var muzzle: Marker2D = $Visuals/Muzzle

var target := Vector2.ZERO

## This method is used for performing az attack with the weapon.
func use_weapon() -> void:
	var old_rotation := visuals.rotation
	
	visuals.look_at(target)
	animation_player.play("use")
	await animation_player.animation_finished
	
	visuals.rotation = old_rotation


func spawn_projectile() -> void:
	var new_projectile := projectile.instantiate()
	get_tree().root.add_child(new_projectile)
	new_projectile.global_position = muzzle.global_position
	new_projectile.launch(target)
