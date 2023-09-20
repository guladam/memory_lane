extends ProgressBar

@onready var panel: Panel = $Panel
@onready var number: Label = %Number


func animate(final_val: int) -> void:
	value = 0
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "value", final_val * 10.0, 0.6)
	tween.tween_property(panel, "scale", Vector2(1.25, 1.25), 0.3)
	tween.tween_interval(0.3)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.3)


func _on_value_changed(_value: float) -> void:
	number.text = str(int(_value/10))
