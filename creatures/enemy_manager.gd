class_name EnemyManager
extends Node2D


@onready var grid: Node2D = $Grid
@onready var air_grid: Node2D = $AirGrid
@onready var melee_attack_anim_range: Marker2D = $MeleeAttackAnimRange
@onready var flying_melee_attack_anim_range: Marker2D = $FlyingMeleeAttackAnimRange
@onready var enemies: Node2D = $Enemies
@onready var enemy_scene := preload("res://creatures/enemy.tscn")
@onready var flying_enemy_scene := preload("res://creatures/flying_enemy.tscn")
@onready var ranged_enemy_scene := preload("res://creatures/ranged_enemy.tscn")
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


func setup(_player_ranged_target: Vector2) -> void:
	player_ranged_target = _player_ranged_target


func spawn_enemy(_enemy_scene: PackedScene) -> void:
	var enemy := _enemy_scene.instantiate()
	enemies.add_child(enemy)
	
	var grid_idx := 5
	while _is_grid_space_taken(grid_idx, enemy.type):
		grid_idx -= 1
	
	enemy.global_position = _get_grid_position_for_enemy(enemy, grid_idx)
	
	var grid_table := _get_grid_table_for_enemy(enemy)
	grid_table[grid_idx] = enemy


func do_enemy_turn() -> void:
	# TODO valami grafika?
	await get_tree().create_timer(1.0).timeout
	await take_turn_with_units(grid_air)
	await take_turn_with_units(grid_ground)
	Events.enemy_turn_ended.emit()


func take_turn_with_units(units: Dictionary) -> void:
	for i in units.keys():
		if not units[i]:
			continue
		
		await units[i].status_effects.apply_status_effects()
	
	for i in units.keys():
		if not units[i]:
			continue
		
		if units[i].in_range(i):
			await attack_with_enemy(units[i])
		else:
			await move_enemy(units[i], i)


func move_enemy(enemy: Enemy, grid_idx: int) -> void:
	enemy.accumulated_movement += enemy.get_speed()
	
	var enemy_grid_steps := int(enemy.accumulated_movement)
	if enemy_grid_steps < 1:
		print("no movement yet!")
		return
	
	enemy.accumulated_movement = 0
	for i in range(1, enemy_grid_steps+1):
		var current_grid_idx = max(1, grid_idx - i)
		if _is_grid_space_taken(current_grid_idx, enemy.type):
			print("the spot is taken at %s for type:%s" % [current_grid_idx, enemy.type])
			return
		
		await enemy.animate_move(_get_grid_position_for_enemy(enemy, current_grid_idx))	
	
	print("moved from %s to %s" % [grid_idx, max(1, grid_idx - enemy_grid_steps)])
	var grid_table := _get_grid_table_for_enemy(enemy)
	grid_table[grid_idx] = null
	grid_table[max(1, grid_idx - enemy_grid_steps)] = enemy


func attack_with_enemy(enemy: Enemy) -> void:
	if enemy.has_melee_weapon():
		var anim_position = _get_melee_attack_anim_pos_for_enemy(enemy)
		await enemy.melee_attack(anim_position)
	else:
		await enemy.ranged_attack(player_ranged_target)


func damage_unit(grid_idx: int) -> void:
	if grid_ground[grid_idx]:
		grid_ground[grid_idx].take_damage(1)


func spawn_enemies_for_turn(turn: int, level_data: LevelData) -> void:
	if not level_data.spawn_table.has(turn):
		return
	
	for enemy in level_data.spawn_table[turn]:
		if enemy:
			spawn_enemy(enemy)


func _is_grid_space_taken(i: int, type: Enemy.Type) -> bool:
	match type:
		Enemy.Type.GROUND:
			return grid_ground[i] != null
		Enemy.Type.FLYING:
			return grid_air[i] != null
	
	return false


func _get_grid_position_for_enemy(enemy: Enemy, grid_idx: int) -> Vector2:
	match enemy.type:
		Enemy.Type.GROUND:
			return grid.get_child(grid_idx - 1).global_position
		Enemy.Type.FLYING:
			return air_grid.get_child(grid_idx - 1).global_position
	
	return Vector2.ZERO


func _get_grid_table_for_enemy(enemy: Enemy) -> Dictionary:
	match enemy.type:
		Enemy.Type.GROUND:
			return grid_ground
		Enemy.Type.FLYING:
			return grid_air
	
	return {}


func _get_melee_attack_anim_pos_for_enemy(enemy: Enemy) -> Vector2:
	match enemy.type:
		Enemy.Type.GROUND:
			return melee_attack_anim_range.global_position
		Enemy.Type.FLYING:
			return flying_melee_attack_anim_range.global_position
	
	return Vector2.ZERO


func _get_all_enemies() -> Array[Node]:
	var all_enemies: Array[Node] = []
	
	for i in grid_air.keys():
		if grid_air[i]:
			all_enemies.append(grid_air[i])
		if grid_ground[i]:
			all_enemies.append(grid_ground[i])
	
	return all_enemies


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


func _on_enemy_died(enemy: Enemy) -> void:
	var table := _get_grid_table_for_enemy(enemy)
	for i in table.keys():
		if table[i] and table[i] == enemy:
			table[i] = null
			print("enemy deleted from grid")
