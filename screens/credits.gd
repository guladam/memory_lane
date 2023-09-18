## This screen shows the [Player] the credits.
extends Control

## Emitted when the player wants to go back to the main menu.
signal main_menu_requested

@onready var back: Button = %Back

func _ready() -> void:
	back.pressed.connect(func(): main_menu_requested.emit())


## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	back.disabled = not enabled
