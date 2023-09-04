## This is the root scene of the game.
class_name Game
extends Node

## How many levels the player needs to beat to win a [Run].
const LEVELS_PER_RUN := 2
## All available [Level]s, represented as an array of [LevelData] resources.
@export var available_levels: Array[LevelData]

@onready var level := preload("res://screens/level.tscn")
@onready var menu_screen := preload("res://screens/menu_screen.tscn")
@onready var card_draft_screen := preload("res://screens/card_draft_screen.tscn")

var current_run: Run

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuScreen.start_new_game.connect(_start_new_game)
	Events.level_won.connect(_on_level_won)


## Stars a new game with the selected [Character].
## [param character] is the selecteed [Character].
func _start_new_game(character: Character) -> void:
	current_run = Run.new()
	current_run.character = character
	current_run.deck = character.starting_deck.duplicate(true)

	_start_level(1)


## Starts a new random level from the pool, based on the current progress.
## [param level_pool] is the number of levels won + 1.
func _start_level(level_pool: int) -> void:
	get_child(0).queue_free()
	
	var new_level := level.instantiate()
	new_level.run = current_run
	new_level.level_data = _get_level(level_pool)
	add_child(new_level)


## Called when the [Player] wins a [Level].
func _on_level_won(_level: LevelData) -> void:
	get_child(0).queue_free()
	
	current_run.current_level += 1
	
	if current_run.current_level > LEVELS_PER_RUN:
		print("woohoo! no more levels gg")
		Events.run_won.emit()
		return
	
	var draft_screen := card_draft_screen.instantiate()
	add_child(draft_screen)
	draft_screen.setup(current_run)
	draft_screen.card_drafted.connect(_on_card_drafted)


## Called when a new card has been drafted.
## [param card] is the [CardData] for the newly drafted card.
func _on_card_drafted(card: CardData) -> void:
	if card:
		current_run.deck.cards.append(card)
		current_run.deck.cards.append(card)
	
	_start_level(current_run.current_level)


## Gets a random level from the pool, based on the progress
##  (i.e. number of beaten levels).
## [param level_pool] is the number of levels won + 1.
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
