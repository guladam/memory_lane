extends Sprite2D


@export var speed := 400
@onready var hit_box: HitBox = $HitBox
var target: Vector2


func launch(_target: Vector2, bonus_damage: int = 0):
	target = _target
	hit_box.set_damage(bonus_damage)


func _process(delta: float) -> void:
	if not target: 
		return
	
	look_at(target)
	var dir := (target - global_position).normalized()
	global_position += dir * speed * delta


func _on_hit_box_area_entered(_area: Area2D) -> void:
	queue_free()
