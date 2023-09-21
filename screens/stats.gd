## This screen shows the [Player] their stats.
extends Control

## Emitted when the player wants to go back to the main menu.
signal main_menu_requested

@onready var back: Button = %Back
@onready var games_played: HBoxContainer = %GamesPlayed
@onready var games_won: HBoxContainer = %GamesWon
@onready var win_rate: HBoxContainer = %WinRate
@onready var levels_beaten: HBoxContainer = %LevelsBeaten
@onready var enemies_killed: HBoxContainer = %EnemiesKilled


func _ready() -> void:
	back.pressed.connect(func(): main_menu_requested.emit())
	
	_set_stat(games_played, StatTracker.all_runs)
	_set_stat(games_won, StatTracker.runs_won)
	_set_stat(levels_beaten, StatTracker.levels_beaten)
	_set_stat(enemies_killed, StatTracker.enemies_killed)
	
	var winrate := StatTracker.runs_won / float(StatTracker.all_runs)
	_set_stat(win_rate, "%.2f%%" % winrate)


func _set_stat(node: HBoxContainer, value: Variant) -> void:
	node.get_node("Value").text = str(value)


## Enables or disables all buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	back.disabled = not enabled
