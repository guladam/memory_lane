extends Node


@onready var level := preload("res://screens/level.tscn")
@onready var menu_screen := preload("res://screens/menu_screen.tscn")

var current_run: Run

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuScreen.start_new_game.connect(start_new_game)


func start_new_game(character: Character) -> void:
	current_run = Run.new()
	current_run.character = character
	current_run.deck = character.starting_deck.duplicate(true)

	get_child(0).queue_free()
	
	var new_level := level.instantiate()
	new_level.run = current_run
	add_child(new_level)
