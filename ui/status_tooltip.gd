## This a tooltip panel for statuses that need further explanation.
extends PanelContainer


@onready var tooltip_lines: VBoxContainer = $MarginContainer/TooltipLines
@onready var tooltip_row: PackedScene = preload("res://ui/tooltip_row.tscn")

var original_pos: Vector2
var _tween: Tween
var statuses: Array[StatusData]


func _ready() -> void:
	hide()


## This method sets up the tooltip text.
## [param _statuses] is the [StatusData] array that holds the information needed.
func setup(_statuses: Array[StatusData]) -> void:
	for status in _statuses:
		var new_tooltip := tooltip_row.instantiate()
		tooltip_lines.add_child(new_tooltip)
		new_tooltip.setup(status.tooltip.icon, status.tooltip.text)


## Fade out animation for the tooltip.
func fade_out() -> void:
	if not visible:
		return
		
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	_tween.parallel().tween_property(self, "position:y", 25, 0.3).as_relative()
	_tween.tween_callback(queue_free)


## Fade in animation for the tooltip.
func fade_in() -> void:
	show()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	_tween.parallel().tween_property(self, "position", original_pos, 0.3).from(original_pos + Vector2(0, 25))
