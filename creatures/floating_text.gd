extends Label


func show_text(start_pos: Vector2, color: Color, message: String) -> void:
	text = message
	set("theme_override_colors/font_color", color)
	position = start_pos
	
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", Vector2(0, -50), 1.0).as_relative()
	t.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	t.tween_callback(queue_free)
