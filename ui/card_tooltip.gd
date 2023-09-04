## This a tooltip panel for cards that need further explanation.
extends Panel

## Emitted when the tooltip is shown.
signal tooltip_shown

@onready var original_pos := position
@onready var tooltip: RichTextLabel = $Tooltip

var _tween: Tween
var card_data: CardData


func _ready() -> void:
	hide()


## This method sets up the tooltip text.
## [param _card_data] is the [CardData] that holds the information needed.
func setup(_card_data: CardData) -> void:
	tooltip.text = _card_data.tooltip


## Toggles the tooltip.
func toggle() -> void:
	var animating := _tween and _tween.is_running()
	var empty := tooltip.text.length() == 0
	
	if animating or empty:
		return
	
	if visible:
		fade_out_tooltip()
	else:
		tooltip_shown.emit()
		_fade_in_tooltip()


## Fade out animation for the tooltip.
func fade_out_tooltip() -> void:
	if not visible:
		return
		
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 0.0, 0.6)
	_tween.parallel().tween_property(self, "position:y", -50, 0.7).as_relative()
	_tween.tween_callback(hide)


## Fade in animation for the tooltip.
func _fade_in_tooltip() -> void:
	show()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "modulate:a", 1.0, 0.6)
	_tween.parallel().tween_property(self, "position", original_pos, 0.7).from(original_pos + Vector2(0, -50))
