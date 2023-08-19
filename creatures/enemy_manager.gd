class_name EnemyManager
extends Node2D


@onready var grid: Node2D = $Grid
@onready var flying_units_spawn: Marker2D = $FlyingUnitsSpawn
@onready var melee_attack_anim_range: Marker2D = $MeleeAttackAnimRange
@onready var enemies: Node2D = $Enemies
@onready var enemy_scene := preload("res://creatures/enemy.tscn")

## Grid representing the current [Enemy] units on the ground.
var grid_ground := {}
## Grid representing the current [Enemy] units in the air.
var grid_air := {}


func _ready() -> void:
	for i in range(1, 6):
		grid_ground[i] = null
		grid_air[i] = null
	spawn_enemy()
	
	Events.player_turn_ended.connect(func(): Events.enemy_turn_started.emit())
	Events.enemy_turn_started.connect(do_enemy_turn)


func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate()
	enemies.add_child(enemy)
	enemy.global_position = _get_grid_position(5)
	grid_ground[5] = enemy
	
	var enemy2 := enemy_scene.instantiate()
	enemies.add_child(enemy2)
	enemy2.global_position = _get_grid_position(4)
	enemy2.movement_speed = 2.5
	grid_ground[4] = enemy2


func do_enemy_turn() -> void:
	await take_turn_with_units(grid_air)
	await take_turn_with_units(grid_ground)
	Events.enemy_turn_ended.emit()


func take_turn_with_units(units: Dictionary) -> void:
	var curr_enemy: Enemy
	
	for i in units.keys():
		curr_enemy = units[i]
		if not curr_enemy:
			continue
			
		if curr_enemy.in_range(i):
			await attack_with_enemy(curr_enemy, i)
		else:
			await move_enemy(curr_enemy, i)


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
		
		await enemy.animate_move(_get_grid_position(current_grid_idx))	
	
	print("moved from %s to %s" % [grid_idx, max(1, grid_idx - enemy_grid_steps)])
	var grid_table := _get_grid_table_for_enemy(enemy)
	grid_table[grid_idx] = null
	grid_table[max(1, grid_idx - enemy_grid_steps)] = enemy


func attack_with_enemy(enemy: Enemy, grid_idx: int) -> void:
	print("%s attacks at %s!" % [enemy, grid_idx])
	await get_tree().create_timer(0.25).timeout


func _is_grid_space_taken(i: int, type: Enemy.Type) -> bool:
	match type:
		Enemy.Type.GROUND:
			return grid_ground[i] != null
		Enemy.Type.FLYING:
			return grid_air[i] != null
	
	return false


func _get_grid_position(grid_idx: int) -> Vector2:
	return grid.get_child(grid_idx - 1).global_position


func _get_grid_table_for_enemy(enemy: Enemy) -> Dictionary:
	match enemy.type:
		Enemy.Type.GROUND:
			return grid_ground
		Enemy.Type.FLYING:
			return grid_air
	
	return {}


# TODO erase units on enemy death
# doc comments
