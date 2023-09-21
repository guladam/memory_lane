## This screen shows the [Player] the tutorial.
extends Control

## Emitted when the player wants to go back to the main menu.
signal main_menu_requested

@onready var back: Button = %Back
@onready var slides: Control = %Slides
@onready var slide_indicators: HBoxContainer = %SlideIndicators
@onready var current_slide := 1

var drag_begin: Vector2


func _ready() -> void:
	back.pressed.connect(func(): main_menu_requested.emit())


func _input(event: InputEvent) -> void:
	if not visible:
		return
#	if event is InputEventScreenDrag:
#		var dist: Vector2 = event.position - drag_begin
#		if abs(dist.x) < 400:
#			return
#
#		change_to_slide(current_slide + sign(dist.x))
	# TODO TEST ON MOBILE!!!
	if event is InputEventMouseButton:
		if event.pressed:
			drag_begin = event.position
			print("drag began at %s" % drag_begin)
		else:
			print("drag end at %s" % event.position)
			var dist: Vector2 = event.position - drag_begin
			if abs(dist.x) < 150:
				return

			change_to_slide(current_slide - sign(dist.x))
		

## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	back.disabled = not enabled


## Changes to a [param new_slide].
func change_to_slide(new_slide: int) -> void:
	new_slide = clampi(new_slide, 1, slides.get_child_count())
	for i in range(slides.get_child_count()):
		if i+1 == new_slide:
			slides.get_child(i).show()
			slide_indicators.get_child(i).set_active(true)
		else:
			slides.get_child(i).hide()
			slide_indicators.get_child(i).set_active(false)
			
	current_slide = new_slide
