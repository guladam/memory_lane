## This class manages spawning and taking turns with [Enemy] units.
class_name EnemyManager
extends Node2D


@onready var grid: Node2D = $Grid
@onready var air_grid: Node2D = $AirGrid
@onready var melee_attack_anim_range: Marker2D = $MeleeAttackAnimRange
@onready var flying_melee_attack_anim_range: Marker2D = $FlyingMeleeAttackAnimRange
@onready var enemies: Node2D = $Enemies
## The position where ranged [Enemy] units will shoot at.
var player_ranged_target: Vector2
## Grid representing the current [Enemy] units on the ground.
var grid_ground := {}
## Grid representing the current [Enemy] units in the air.
var grid_air := {}


func _ready() -> void:
	for i in range(1, 6):
		grid_ground[i] = null
		grid_air[i] = null
	
	Events.player_turn_ended.connect(func(): Events.enemy_turn_started.emit())
	Events.enemy_turn_started.connect(do_enemy_turn)
	Events.effect_created.connect(_on_effect_created)
	Events.enemy_died.connect(_on_enemy_died)


## This method is used to inject a dependency for ranged units.
## They need to know where to aim before shooting.
## [param _player_ranged_target] is the position of the [Player].
func setup(_player_ranged_target: Vector2) -> void:
	player_ranged_target = _player_ranged_target


## Spawns an [Enemy] unit in the furthest available grid.
## [param _enemy_scene] is the [Enemy] unit to spawn.
func spawn_enemy(_enemy_scene: PackedScene) -> void:
	var enemy := _enemy_scene.instantiate()
	enemies.add_child(enemy)
	
	var grid_idx := 5
	while _is_grid_space_taken(grid_idx, enemy.type):
		grid_idx -= 1
	
	enemy.global_position = _get_grid_position_for_enemy(enemy, grid_idx)
	
	var grid_table := _get_grid_table_for_enemy(enemy)
	grid_table[grid_idx] = enemy
	
	update_unit_intentions(air_grid, grid_air)
	update_unit_intentions(grid, grid_ground)


## Completes the full enemy turn, unit by unit.
## This is a coroutine as it waits for the units to finish their actions.
func do_enemy_turn() -> void:
	# TODO valami grafika?
	await get_tree().create_timer(1.0).timeout
	await take_turn_with_units(grid_air)
	await take_turn_with_units(grid_ground)
	update_unit_intentions(air_grid, grid_air)
	update_unit_intentions(grid, grid_ground)
	Events.enemy_turn_ended.emit()


## Iterates over a type of enemies and takes turns with them one by one.
## [param units] is a [Dictionary] with all the [Enemy] units for a given type.
## This method is used by [method EnemyManager.do_enemy_turn].
func take_turn_with_units(units: Dictionary) -> void:
	for i in units.keys():
		if not units[i]:
			continue
		
		await units[i].status_effects.apply_status_effects()
	
	for i in units.keys():
		if not units[i]:
			continue
		
		var intent: Enemy.Intents = _get_enemy_intent(units[i], i)
		
		if intent == Enemy.Intents.MOVE:
			await move_enemy(units[i], i)
		else:
			await attack_with_enemy(units[i])


## Iterates over a type of enemies and updates their intentions one by one.
## [param marker_parent] is the parent Node holding all markers,
## [param units] is the Dictionary containing unit information.
func update_unit_intentions(marker_parent: Node, units: Dictionary) -> void:
	for i in marker_parent.get_child_count():
		if not units[i+1]:
			marker_parent.get_child(i).change_color(Enemy.Intents.NONE)
			continue
		
		var intent: Enemy.Intents = _get_enemy_intent(units[i+1], i+1)
		marker_parent.get_child(i).change_color(intent)


## Moves an [Enemy] according to its movement speed.
## [param enemy] is the [Enemy] unit,
## [param grid_idx] is the starting position of the unit.
func move_enemy(enemy: Enemy, grid_idx: int) -> void:
	enemy.accumulated_movement += enemy.get_speed()
	
	var enemy_grid_steps := int(enemy.accumulated_movement)
	if enemy_grid_steps < 1:
		print("no movement yet!")
		return
	
	enemy.accumulated_movement = 0
	var grid_table := _get_grid_table_for_enemy(enemy)
	
	
	for i in range(1, enemy_grid_steps+1):
		var current_grid_idx = max(1, grid_idx - i)
		if _is_grid_space_taken(current_grid_idx, enemy.type):
			print("the spot is taken at %s for type:%s" % [current_grid_idx, enemy.type])
			return
		
		await enemy.animate_move(_get_grid_position_for_enemy(enemy, current_grid_idx))	
	
		print("moved from %s to %s" % [grid_idx, current_grid_idx])
		## TODO THIS MIGHT BE WRONG, MIGHT DELETE UNRELATED UNITS,
		## NEEDS TO BE CHECKED ON PAPER
		grid_table[current_grid_idx + 1] = null
		grid_table[current_grid_idx] = enemy


## Performs an attack with the [Enemy] unit.
## [param enemy] is the attacking unit.
func attack_with_enemy(enemy: Enemy) -> void:
	if enemy.has_melee_weapon():
		var anim_position = _get_melee_attack_anim_pos_for_enemy(enemy)
		await enemy.melee_attack(anim_position)
	else:
		await enemy.ranged_attack(player_ranged_target)


## Deals one damage to an [Enemy] unit in a given index,
## prioritizing ground units.
## [param grid_idx] is the grid position of the unit.
## Note: this method is only used for debugging.
func damage_unit(grid_idx: int) -> void:
	if grid_ground[grid_idx]:
		grid_ground[grid_idx].take_damage(1)
	elif grid_air[grid_idx]:
		grid_air[grid_idx].take_damage(1)


## Spawns the [Enemy] units according the Spawn Table of the current [Level]'s
## [LevelData]. This should be called in every turn.
## [param turn] is the turn counter,
## [parram level_data] is the [LevelData] resource for the current [Level].
func spawn_enemies_for_turn(turn: int, level_data: LevelData) -> void:
	if not level_data.spawn_table.has(turn):
		return
	
	for enemy in level_data.spawn_table[turn]:
		if enemy:
			spawn_enemy(enemy)


## Returns the appropriate [enum Enemy.Intents] for the [Enemy] unit.
## [param enemy] is the unit in question, at [param grid_idx] position.
func _get_enemy_intent(enemy: Enemy, grid_idx: int) -> Enemy.Intents:
	var can_move_up: bool = grid_idx > 1 and not _is_grid_space_taken(grid_idx - 1, enemy.type)
	var has_unit_behind: bool = grid_idx < 5 and _is_grid_space_taken(grid_idx + 1, enemy.type)

	if can_move_up and has_unit_behind:
		return Enemy.Intents.MOVE
	elif enemy.in_range(grid_idx):
		return Enemy.Intents.ATTACK
	else:
		return Enemy.Intents.MOVE


## Returns [code]true[/code] if a given grid is taken by a specific type of [Enemy].
## [param i] is the grid index,
## [param type] is the [enum Enemy.Type] of the enemy unit.
func _is_grid_space_taken(i: int, type: Enemy.Type) -> bool:
	match type:
		Enemy.Type.GROUND:
			return grid_ground[i] != null
		Enemy.Type.FLYING:
			return grid_air[i] != null
	
	return false


## Returns the position of any given [Enemy] unit, in global coordinates.
## [param enemy] is the [Enemy] unit which is needed to get the correct type.
## [param grid_idx] is the grid position of the unit.
func _get_grid_position_for_enemy(enemy: Enemy, grid_idx: int) -> Vector2:
	match enemy.type:
		Enemy.Type.GROUND:
			return grid.get_child(grid_idx - 1).global_position
		Enemy.Type.FLYING:
			return air_grid.get_child(grid_idx - 1).global_position
	
	return Vector2.ZERO


## Returns the matching grid table ([Dictionary]) for a given [Enemy].
## [param enemy] is the [Enemy] unit.
func _get_grid_table_for_enemy(enemy: Enemy) -> Dictionary:
	match enemy.type:
		Enemy.Type.GROUND:
			return grid_ground
		Enemy.Type.FLYING:
			return grid_air
	
	return {}


## Gets the starting position for a melee attack for an [Enemy] unit
## with a [MeleeWeapon].
## [param enemy] is the [Enemy] unit.
func _get_melee_attack_anim_pos_for_enemy(enemy: Enemy) -> Vector2:
	match enemy.type:
		Enemy.Type.GROUND:
			return melee_attack_anim_range.global_position
		Enemy.Type.FLYING:
			return flying_melee_attack_anim_range.global_position
	
	return Vector2.ZERO


## Returns all present [Enemy] units in an [Array].
func _get_all_enemies() -> Array[Node]:
	var all_enemies: Array[Node] = []
	
	for i in grid_air.keys():
		if grid_air[i]:
			all_enemies.append(grid_air[i])
		if grid_ground[i]:
			all_enemies.append(grid_ground[i])
	
	return all_enemies


## Returns the first available target for an [Effect].
## This method is only useful for single-target [Effects].
## [param effect] is the [Effect] which needs to get a target.
func _get_target_for_effect(effect: Effect) -> Array[Node]:
	match effect.target_type:
		Effect.TargetType.AIR:
			for i in grid_air.keys():
				if grid_air[i]:
					return [grid_air[i]]
		effect.TargetType.GROUND:
			for i in grid_ground.keys():
				if grid_ground[i]:
					return [grid_ground[i]]
	
	return []


## Called when an [Effect] is created by the [Player].
## This is usually done by matching two cards together.
## [param effect] is created [Effect].
func _on_effect_created(effect: Effect) -> void:
	if not effect:
		return
	
	var valid_targets := [
		Effect.TargetType.AIR,
		Effect.TargetType.GROUND,
		Effect.TargetType.ALL_ENEMIES,
	]
	
	if not valid_targets.has(effect.target_type):
		return

	print("enemy effect should apply")
	var target: Array[Node]
	if effect.target_type == Effect.TargetType.ALL_ENEMIES:
		target = _get_all_enemies()
	else:
		target = _get_target_for_effect(effect)
		
	effect.setup(target)
	effect.apply_effect()


## Called when an [Enemy] unit dies.
## [param enemy] is the dead [Enemy].
func _on_enemy_died(enemy: Enemy) -> void:
	var table := _get_grid_table_for_enemy(enemy)
	for i in table.keys():
		if table[i] and table[i] == enemy:
			table[i] = null
			print("enemy deleted from grid")
