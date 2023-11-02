## Stat Tracker for tracking in-game progress and statistics.
## This is a Singleton Class added as an autoload.
extends Node

## Total number of enemies killed while playing the game.
var enemies_killed: int
## Total number of enemies killed while playing the game.
var enemies_killed_this_run: int
## Total number of levels beaten while playing the game.
var levels_beaten: int
## Total number of runs won while playing the game.
var runs_won: int
## Total number of runs played.
var all_runs: int
## Number of rerolls available when drafting cards.
var rerolls: int

## [code]true[/code] if the [Player] has unlocked this character.
var ice_unlocked: bool
## [code]true[/code] if the [Player] has unlocked this character.
var earth_unlocked: bool


func _ready() -> void:
	_initialize()
	
	Events.enemy_died.connect(_on_enemy_died)
	Events.level_won.connect(_on_level_won)
	Events.game_over.connect(_on_game_over)
	Events.run_won.connect(_on_run_won)
	Events.card_rewards_rerolled.connect(_on_card_rewards_rerolled)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_stats"):
		print_stats()


## Initializes the StatTracker when the game starts.
## Either saves the default values or loads the stats from the disk.
func _initialize() -> void:
	var _stats := FileAccess.open("user://stats.save", FileAccess.READ)
	if not _stats:
		_save_default()
	else:
		_load_data(_stats)


## Saves the default stats.
## Can be used if there is no saved file available.
func _save_default() -> void:
	enemies_killed = 0
	enemies_killed_this_run = 0
	levels_beaten = 0
	runs_won = 0
	all_runs = 0
	rerolls = 3
	
	ice_unlocked = false
	earth_unlocked = false
	_save_stats()


## Saves the current stats on the disk.
func _save_stats() -> void:
	var _stats := FileAccess.open("user://stats.save", FileAccess.WRITE)
	if not _stats:
		print("error while saving stats!")
		return
	
	_stats.store_var(enemies_killed)
	_stats.store_var(enemies_killed_this_run)
	_stats.store_var(levels_beaten)
	_stats.store_var(runs_won)
	_stats.store_var(all_runs)
	_stats.store_var(rerolls)
	_stats.store_var(ice_unlocked)
	_stats.store_var(earth_unlocked)


## Sets the member variables from loaded data.
## [param file] is the loaded save file.
func _load_data(file: FileAccess) -> void:
	enemies_killed = file.get_var()
	enemies_killed_this_run = file.get_var()
	levels_beaten = file.get_var()
	runs_won = file.get_var()
	all_runs = file.get_var()
	rerolls = file.get_var()
	ice_unlocked = file.get_var()
	earth_unlocked = file.get_var()


## Prints the current stats. Useful for debugging.
func print_stats() -> void:
	print("STATS\n-------------------")
	print("enemies killed: %s" % enemies_killed)
	print("enemies killed this run: %s" % enemies_killed_this_run)
	print("levels beaten: %s" % levels_beaten)
	print("runs won: %s" % runs_won)
	print("all runs: %s" % all_runs)
	print("rerolls: %s" % rerolls)
	print("ice: %s" % ice_unlocked)
	print("earth: %s" % earth_unlocked)
	print("-------------------")


## Called when an enemy dies in-game.
func _on_enemy_died(_enemy: Enemy) -> void:
	enemies_killed += 1
	enemies_killed_this_run += 1
	_save_stats()


## Called when the [Player] wins a [Level].
func _on_level_won(level: LevelData) -> void:
	levels_beaten += 1
	
	print("should we unlock ice char at %s" % level.level_pool)
	if level.level_pool >= 6:
		print("yes we should indeed")
		ice_unlocked = true
	
	if levels_beaten % 4 == 0:
		rerolls += 1
	
	_save_stats()


## Called when the [Player] loses a [Run].
func _on_game_over() -> void:
	all_runs += 1
	_save_stats()


## Called when the [Player] wins a whole [Run].
func _on_run_won() -> void:
	runs_won += 1
	all_runs += 1
	earth_unlocked = true
	_save_stats()


## Called when the [Player] rerolls their card rewards.
func _on_card_rewards_rerolled() -> void:
	rerolls -= 1
	_save_stats()
