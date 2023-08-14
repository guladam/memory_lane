extends HBoxContainer

@onready var time_scale_slider: HSlider = $TimeScaleSlider
@onready var value: Label = $Value


func _on_time_scale_slider_value_changed(new_value: float) -> void:
	Engine.time_scale = new_value / 100.0
	value.text = "%s%%" % int(new_value)
