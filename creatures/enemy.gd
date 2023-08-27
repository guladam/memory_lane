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
## [Weapon] used by this enemy.
@export var weapon: Weapon

@onready var health: Health = $Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var movement_modifiers: Modifiers = $MovementModifiers
@onready var status_effects: StatusEffects = $StatusEffects


## TODO document correctly movement if slowed
var accumulated_movement := 0.0


func _ready() -> void:
	health.changed.connect(_on_health_changed)
	health.max_health_changed.connect(health_bar.setup)
	
	health_bar.setup(health.max_health)


## This method is mandatory for creatures having a [Hurtbox].
## [param damage] is the amount of damage to take.
func take_damage(damage: int) -> void:
	health.health -= damage
	animation_player.play("damage")
	await animation_player.animation_finished


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
	if global_position == target:
		return
	
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
## [param distance] is the current distance of the unit from the [Player].
func in_range(distance: int) -> bool:
	return distance <= weapon.attack_range


## Attacks the player if in range.
## [param attack_position] is used for melee attack animation.
func melee_attack(attack_position: Vector2) -> void:
	if not has_melee_weapon():
		return
		
	var starting_pos := global_position
	await animate_move(attack_position)
	
	@warning_ignore("redundant_await")
	await weapon.use_weapon()
	
	await animate_move(starting_pos)


## Performs a ranged attack.
## [param target] is the position to shoot towards.
func ranged_attack(target: Vector2) -> void:
	if has_melee_weapon():
		return
	
	weapon.target = target
	
	@warning_ignore("redundant_await")
	await weapon.use_weapon()


## Returns the current speed of the unit, in grids.
func get_speed() -> float:
	return movement_speed * movement_modifiers.get_modifier()


func has_melee_weapon() -> bool:
	return weapon is MeleeWeapon
	

func _on_health_changed(new_hp: int) -> void:
	health_bar.update_health.call_deferred(new_hp)
	if new_hp <= 0:
		Events.enemy_died.emit(self)
		#animation_player.play("die")
		queue_free()
		print("enemy died")
