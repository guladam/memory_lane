## Class representing Enemy characters.
## This class is responsible for moving the character and 
## handling health-related functions. 
## For dealing damage, check the [Weapon] class.
class_name Enemy
extends Sprite2D

## Emitted when an [Enemy] finished performing its action for the turn.
signal action_finished

enum Type {GROUND, FLYING}

## Type of this [Enemy].
@export var type: Type
## Determines how many grid spaces the [Enemy] can move in 1 turn.
@export var movement_speed := 1.0
## Animation speed for moving, in one grid / second format.
@export var movement_anim_speed := 1.0
## TODO this comes from weapons, refactor this
@export var atk_range := 1

@onready var health: Health = $Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var movement_modifiers: Modifiers = $MovementModifiers

## TODO document correctly movement if slowed
var accumulated_movement := 0.0


func _ready() -> void:
	health.changed.connect(
		func(new_hp): health_bar.update_health.call_deferred(new_hp)
	)
	health.max_health_changed.connect(health_bar.setup)


## This method is mandatory for creatures having a [Hurtbox].
## [param damage] is the amount of damage to take.
func take_damage(damage: int) -> void:
	health.health -= damage


## This method is for healing the enemy.
## [param amount] is the amount of health restored.
func heal(amount: int) -> void:
	health.health += amount


## Changes the maximum health of the enemy.
## [param amount] is the amount of change.
func change_max_health(amount: int) -> void:
	health.max_health += amount


## Moves the enemy to the target position.
## [param target] is where the [Enemy] ends up at the end.
## This is a coroutine as it waits for the animation to finish.
func animate_move(target: Vector2) -> void: 
	var anim_length := movement_anim_speed * movement_modifiers.get_modifier()
	animation_player.play("walk")
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target, anim_length)
	tween.tween_interval(0.15)
	await tween.finished
	animation_player.play("idle")


## Changes the movement speed of the [Enemy].
## [param amount] is the amount of change, in percentages. 
## [param turns] is the number of turns the modifier is applied. 
## If it's zero, the modifier is permanent.
func change_speed(amount: float, turns=0) -> void:
	if turns > 0:
		movement_modifiers.new_temporary_modifier(amount, turns)
	else:
		movement_modifiers.new_modifier(amount)


## Returns [code]true[/code] if the unit is withing attacking range.
func in_range(distance: int) -> bool:
	print("distance: ", distance)
	return distance == 1


## Attacks the player if in range.
func attack() -> void:
	print("attack!")


## Returns the current speed of the unit, in grids.
func get_speed() -> float:
	return movement_speed * movement_modifiers.get_modifier()
