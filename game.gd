extends Node


@export var available_levels: Array[LevelData]

@onready var level := preload("res://screens/level.tscn")
@onready var menu_screen := preload("res://screens/menu_screen.tscn")
@onready var card_draft_screen := preload("res://screens/card_draft_screen.tscn")

var current_run: Run

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuScreen.start_new_game.connect(_start_new_game)
	Events.level_won.connect(_on_level_won)


func _start_new_game(character: Character) -> void:
	current_run = Run.new()
	current_run.character = character
	current_run.deck = character.starting_deck.duplicate(true)

	_start_level(1)


func _start_level(level_pool: int) -> void:
	get_child(0).queue_free()
	
	var new_level := level.instantiate()
	new_level.run = current_run
	new_level.level_data = _get_level(level_pool)
	add_child(new_level)


func _on_level_won() -> void:
	get_child(0).queue_free()
	
	current_run.current_level += 1
	
	## TODO CHECK IF WON
	if current_run.current_level > 2:
		print("woohoo! no more levels gg")
		return
	
	var draft_screen := card_draft_screen.instantiate()
	add_child(draft_screen)
	draft_screen.setup(current_run)
	draft_screen.card_drafted.connect(_on_card_drafted)


func _on_card_drafted(card: CardData) -> void:
	if card:
		current_run.deck.cards.append(card)
		current_run.deck.cards.append(card)
	
	_start_level(current_run.current_level)


func _get_level(level_pool: int) -> LevelData:
	var possible_levels := available_levels.filter(
		func(_level: LevelData):
			return _level.level_pool == level_pool
	)
	
	if possible_levels.is_empty():
		print("no more levels!")
		return null
	
	randomize()
	return possible_levels.pick_random()
