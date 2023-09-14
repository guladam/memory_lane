## This screen is shown when you start the game.
extends ColorRect

## Emitted when the player wants to see the credits.
signal credits_requested
## Emitted when the player wants to start a new game.
signal new_game_requested

@onready var play: Button = %Play
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit())
	credits.pressed.connect(func(): credits_requested.emit())
	quit.pressed.connect(get_tree().quit)


## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	credits.disabled = not enabled
	quit.disabled = not enabled
