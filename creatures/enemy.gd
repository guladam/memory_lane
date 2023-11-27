## Class representing Enemy characters.
## This class is responsible for moving the character and 
## handling health-related functions. 
## For dealing damage, check the [Weapon] class.
class_name Enemy
extends Node2D

## Emitted when an [Enemy] finished performing its action for the turn.
signal action_finished

enum Type {GROUND, FLYING}
## Intents of the [Enemy] unit.
enum Intents {NONE, ATTACK, MOVE}


## Type of this [Enemy].
@export var type: Type
## Determines how many grid spaces the [Enemy] can move in 1 turn.
@export var movement_speed := 1.0
## Animation speed for moving, in one grid / second format.
@export var movement_anim_speed := 1.0
## Animation player for the enemy. It needs to be injected, so each 
## enemy can have their own unique animations.
@export var custom_anim_player: AnimationPlayer
## [Weapon] used by this enemy.
@export var weapon: Weapon
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health: Health = $Health as Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var movement_modifiers: Modifiers = $MovementModifiers as Modifiers
@onready var status_effects: StatusEffects = $StatusEffects as StatusEffects
@onready var floating_text_position: Marker2D = $FloatingTextPosition
@onready var floating_text := preload("res://creatures/floating_text.tscn")
@onready var status_highlight := preload("res://ui/status_highlighter.tscn")
@onready var puff_effect := preload("res://creatures/puff_effect.tscn")

## This variable is used to calculate how many grid spaces
## an enemy can move. If it's less than 0, the accumulated
## float value is stored for the next turn(s).
var accumulated_movement := 0.0
## This is used to decide which [AnimationPlayer] this enemy uses.
## Each can use their own unique animation but we provide a default
## one if there are no unique animations provided.
var animations: AnimationPlayer


func _ready() -> void:
	health.changed.connect(_on_health_changed)
	health.max_health_changed.connect(health_bar.setup)
	health.reached_zero.connect(_on_health_reached_zero)
	
	health_bar.setup(health.max_health)
	
	if custom_anim_player:
		animation_player.queue_free()
		animations = custom_anim_player
	else:
		animations = animation_player


## This method is mandatory for creatures having a [Hurtbox].
## [param damage] is the amount of damage to take.
func take_damage(damage: int) -> void:
	health.health -= damage
	_create_floating_text("-%s" % damage, Color.RED)
	
	if health.health > 0:
		animations.play("damage")
		await animations.animation_finished
		animations.play("idle")


## This method is for healing the enemy.
## [param amount] is the amount of health restored.
func heal(amount: int) -> void:
	health.health += amount
	_create_floating_text("+%s" % amount, Color.GREEN)


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
	animations.play("walk")
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target, anim_length)
	tween.tween_interval(0.15)
	await tween.finished
	animations.play("idle")


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
	
	if weapon.self_damage > 0:
		take_damage(weapon.self_damage)
	
	if health.health > 0:
		await animate_move(starting_pos)


## Performs a ranged attack.
## [param target] is the position to shoot towards.
func ranged_attack(target: Vector2) -> void:
	if has_melee_weapon():
		return
	
	weapon.target = target
	
	@warning_ignore("redundant_await")
	await weapon.use_weapon()
	animations.play("idle")


## Plays the sound associated with the weapon.
func play_weapon_sound() -> void:
	SfxPlayer.play(weapon.sound)


## Returns the current speed of the unit, in grids.
func get_speed() -> float:
	print("original movement: %s | w/ modifiers: %s" % [movement_speed, movement_speed*movement_modifiers.get_modifier()])
	return movement_speed * movement_modifiers.get_modifier()


## Returns true if the enemy wields a [MeleeWeapon].
func has_melee_weapon() -> bool:
	return weapon is MeleeWeapon


## Returns the center Y offset for the enemy sprite.
func get_center_y_offset() -> float:
	return sprite_2d.get_rect().size.y / 2.0


## Creates a floating text for this enemy.
## [param text] is the text to be displayed,
## [param color] is the color of the message.
func _create_floating_text(text: String, color: Color) -> void:
	var new_floating_text := floating_text.instantiate()
	get_tree().root.add_child(new_floating_text)
	new_floating_text.show_text(floating_text_position.global_position, color, text)


## Creates a status highlight effect when a [Status] applies
## to the unit.
## [param icon] is the [Texture] to show.
func create_status_highlight(icon: Texture) -> void:
	var new_status_highlight := status_highlight.instantiate()
	var highlight_position = floating_text_position.global_position + Vector2.UP * 30
	get_tree().root.add_child(new_status_highlight)
	new_status_highlight.show_text(highlight_position, icon)


## Called when the enemy's health is changed.
func _on_health_changed(new_hp: int) -> void:
	health_bar.update_health.call_deferred(new_hp)


## Called when the enemy's health reaches 0.
func _on_health_reached_zero() -> void:
	Events.enemy_died.emit(self)
	var puff = puff_effect.instantiate()
	get_tree().root.add_child(puff)
	puff.global_position = global_position
	queue_free()


## If the enemy is tapped on, show their statuses if there are any.
func _on_hurt_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("tap"):
		Events.status_tooltip_requested.emit(status_effects.get_all_status_data(), self)
