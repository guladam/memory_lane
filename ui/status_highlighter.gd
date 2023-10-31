extends TextureRect

@onready var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


## Shows an animates the floating text.
## [param start_pos] is where the text appears,
## [param color] is the color of the text,
## [param message] is the message to be displayed.
func show_text(start_pos: Vector2, icon: Texture) -> void:
	position = start_pos
	texture = icon
	
	t.tween_property(self, "position", Vector2(0, -50), 2.0).as_relative()
	t.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 2.0)
	t.tween_callback(queue_free)
