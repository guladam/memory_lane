## This screen is shown when a level is finished, either by
## winning it, or when the [Player] has died.
class_name LevelEndScreen
extends ColorRect

signal continue_selected
signal main_menu_selected

@onready var text_1: Label = $Text1
@onready var text_2: Label = $Text2
@onready var wizard: Control = $Wizard
@onready var levels_won: HBoxContainer = %LevelsWon
@onready var enemies_killed: HBoxContainer = %"Enemies Killed"
@onready var levels_won_progress_bar: ProgressBar = %LevelsWonProgressBar
@onready var enemies_killed_progress_bar: ProgressBar = %EnemiesKilledProgressBar
@onready var next_level: Button = %NextLevel
@onready var main_menu: Button = %MainMenu
@onready var puff := preload("res://creatures/puff_effect.tscn")

var current_level: int
var current_kills: int


func _ready() -> void:
	wizard.hide()
	levels_won.hide()
	enemies_killed.hide()
	next_level.hide()
	main_menu.hide()
	
	next_level.pressed.connect(func(): continue_selected.emit())
	main_menu.pressed.connect(func(): main_menu_selected.emit())


## Shows the level won version, based on the current [Run] data.
func show_level_won(run: Run) -> void:
	text_1.text = "Level"
	text_2.text = "Won"
	current_level = run.current_level
	current_kills = StatTracker.enemies_killed_this_run
	animate("win", next_level)


## Shows the game over version, based on the current [Run] data.
func show_game_over(run: Run) -> void:
	text_1.text = "Game"
	text_2.text = "Over"
	current_level = run.current_level
	current_kills = StatTracker.enemies_killed_this_run
	animate("die", main_menu)


## Animates the screen. Needs the correct [param anim_name] for the wizard
## and the corresponding [Button] to show.
func animate(anim_name: String, button: Button) -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(text_1, "position:x", text_1.position.x, 0.7).from(text_1.position.x - 200)
	tween.parallel().tween_property(text_1, "modulate:a", 1.0, 0.4).from(0.0)
	tween.parallel().tween_property(text_2, "position:x", text_2.position.x, 0.7).from(text_2.position.x + 200)
	tween.parallel().tween_property(text_2, "modulate:a", 1.0, 0.4).from(0.0)
	
	tween.tween_callback(wizard.show)
	tween.tween_property(wizard, "modulate:a", 1.0, 0.2).from(0.0)
	tween.tween_callback(wizard.get_node("AnimationPlayer").play.bind(anim_name))
	tween.tween_interval(2.0)
	
	tween.tween_callback(levels_won.show)
	tween.tween_callback(levels_won_progress_bar.animate.bind(current_level))
	tween.tween_interval(1.5)
	tween.tween_callback(enemies_killed.show)
	tween.tween_callback(enemies_killed_progress_bar.animate.bind(current_kills))
	tween.tween_interval(1.5)
	
	tween.tween_callback(button.show)
	tween.parallel().tween_property(button, "modulate:a", 1.0, 0.4).from(0.0)


## Adds a puff effect to the Wizard's die animation.
func add_wizard_puff() -> void:
	var new_puff := puff.instantiate()
	new_puff.scale = Vector2(3, 3)
	wizard.add_child(new_puff)