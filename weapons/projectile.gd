## Base class for any ranged projectiles.
extends Node2D


## The travel speed of the projectile.
@export var speed := 400
## A Scene to be instantiated on impact.
@export var impact_vfx: PackedScene
@onready var hit_box: HitBox = $HitBox
## The target of this projectile, in global coordinates.
var target: Vector2


## Launches the projectile at a target.
## [param _target] is the target position,
## [param bonus_damage] is the bonus damage to add to the [HitBox]'s base damage.
func launch(_target: Vector2, bonus_damage: int = 0):
	target = _target
	hit_box.set_damage(bonus_damage)


func _process(delta: float) -> void:
	if not target: 
		return
	
	look_at(target)
	var dir := (target - global_position).normalized()
	global_position += dir * speed * delta


func _on_hit_box_area_entered(area: Area2D) -> void:
	Events.projectile_hit.emit()
	if impact_vfx:
		var new_vfx := impact_vfx.instantiate()
		new_vfx.global_position = area.owner.global_position
		get_tree().root.add_child(new_vfx)
	queue_free()
