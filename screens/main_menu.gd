## This screen is shown when you start the game.
extends Control

## Emitted when the player wants to start a new game.
signal new_game_requested
## Emitted when the player wants to see the stats.
signal stats_requested
## Emitted when the player wants to see the tutorial.
signal tutorial_requested
## Emitted when the player wants to see the credits.
signal credits_requested

@onready var play: Button = %Play
@onready var stats: Button = %Stats
@onready var how_to_play: Button = %HowToPlay
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit())
	stats.pressed.connect(func(): stats_requested.emit())
	how_to_play.pressed.connect(func(): tutorial_requested.emit())
	credits.pressed.connect(func(): credits_requested.emit())
	quit.pressed.connect(get_tree().quit)


## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	stats.disabled = not enabled
	how_to_play.disabled = not enabled
	credits.disabled = not enabled
	quit.disabled = not enabled
