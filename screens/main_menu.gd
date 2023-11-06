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
@onready var theme_song: AudioStream = preload("res://music/main_music_loop.ogg")

func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit())
	stats.pressed.connect(func(): stats_requested.emit())
	how_to_play.pressed.connect(func(): tutorial_requested.emit())
	credits.pressed.connect(func(): credits_requested.emit())
	quit.pressed.connect(get_tree().quit)
	MusicPlayer.play_song(theme_song)


## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	stats.disabled = not enabled
	how_to_play.disabled = not enabled
	credits.disabled = not enabled
	quit.disabled = not enabled


## Enables or disables sound effects.
func _on_sound_toggle_toggled(button_pressed: bool) -> void:
	var sfx_bus := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus, button_pressed)


## Enables or disables music.
func _on_music_toggle_toggled(button_pressed: bool) -> void:
	var sfx_bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(sfx_bus, button_pressed)
