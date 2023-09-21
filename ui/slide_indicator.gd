extends Panel


@onready var active := preload("res://ui/slide_indicator_box_active.tres")
@onready var inactive := preload("res://ui/slide_indicator_box_inactive.tres")


func set_active(_active: bool) -> void:
	var panel: StyleBoxFlat = active if _active else inactive
	set("theme_override_styles/panel", panel)
