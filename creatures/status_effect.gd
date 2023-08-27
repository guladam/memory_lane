extends Control

@onready var icon: TextureRect = $Icon
@onready var turn_counter: Label = $TurnCounter


func setup(status: Status) -> void:
	icon.texture = status.icon_texture
	if status.duration > 0:
		turn_counter.text = str(status.duration)
	else:
		turn_counter.hide()


func update() -> void:
	var new_duration := int(turn_counter.text) - 1
	
	if new_duration <= 0:
		queue_free()
		return
			
	turn_counter.text = str(new_duration)
