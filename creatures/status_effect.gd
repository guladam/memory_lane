## This Scene displays a [Status] under a character.
## It has an icon and (optionally) a turn counter.
extends Control

@onready var icon: TextureRect = $Icon
@onready var turn_counter: Label = $TurnCounter

var permanent: bool


## This is used to inject the dependencies of the 
## [Status] effect for the visuals. 
func setup(status: Status) -> void:
	icon.texture = status.icon_texture
	permanent = status.duration <= 0
	
	if not permanent:
		turn_counter.text = str(status.duration)
	else:
		turn_counter.hide()


## This is called every turn to update the turn counter.
## Only does anything if its not a permanent [Status].
func update() -> void:
	if permanent:
		return

	var new_duration := int(turn_counter.text) - 1
	
	if new_duration <= 0:
		queue_free()
		return
			
	turn_counter.text = str(new_duration)
