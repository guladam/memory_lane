extends Label


## Shows an animates the floating text.
## [param start_pos] is where the text appears,
## [param color] is the color of the text,
## [param message] is the message to be displayed.
func show_text(start_pos: Vector2, color: Color, message: String) -> void:
	text = message
	set("theme_override_colors/font_color", color)
	position = start_pos
	position.x += randi_range(-8, 8)
	
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", Vector2(0, -50), 2.0).as_relative()
	t.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 2.0)
	t.tween_callback(queue_free)
