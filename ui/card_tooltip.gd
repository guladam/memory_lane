## This a tooltip panel for cards that need further explanation.
extends PanelContainer


@onready var tooltip_lines: VBoxContainer = $MarginContainer/TooltipLines
@onready var tooltip_row: PackedScene = preload("res://ui/tooltip_row.tscn")

var original_pos: Vector2
var _tween: Tween
var card_data: CardData


func _ready() -> void:
	hide()


## This method sets up the tooltip text.
## [param _card_data] is the [CardData] that holds the information needed.
func setup(_card_data: CardData) -> void:
	for tooltip in _card_data.tooltips:
		var new_tooltip := tooltip_row.instantiate()
		tooltip_lines.add_child(new_tooltip)
		new_tooltip.setup(tooltip.icon, tooltip.text)


## Fade out animation for the tooltip.
func fade_out() -> void:
	if not visible:
		return
		
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	_tween.parallel().tween_property(self, "position:y", -20, 0.3).as_relative()
	_tween.tween_callback(queue_free)


## Fade in animation for the tooltip.
func fade_in() -> void:
	show()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	_tween.parallel().tween_property(self, "position", original_pos, 0.3).from(original_pos + Vector2(0, -50))
