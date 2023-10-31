## Class representing the Player character.
class_name Player
extends Node2D

@onready var health: Health = $Health as Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var ranged_target_position: Marker2D = $RangedTargetPosition
@onready var staff_end: Marker2D = $StaffEnd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bonus_damage: Modifiers = $BonusDamage as Modifiers
@onready var status_effects: StatusEffects = $StatusEffects as StatusEffects
@onready var floating_text_position: Marker2D = $FloatingTextPosition
@onready var floating_text := preload("res://creatures/floating_text.tscn")
@onready var status_highlight := preload("res://ui/status_highlighter.tscn")
var game_state: GameState


func _ready() -> void:
	Events.effect_created.connect(_on_effect_created)
	Events.projectile_spawn_requested.connect(spawn_projectile)
	Events.player_damage_modifier_requested.connect(bonus_damage.new_temporary_modifier)
	health.changed.connect(_on_health_changed)
	health.max_health_changed.connect(health_bar.setup)
	health.reached_zero.connect(_on_health_reached_zero)
	
	health_bar.setup(health.max_health)
	animation_player.play("idle")


## Injects [Character] dependency to the player.
func setup(character: Character, state: GameState) -> void:
	$Eyes.color = character.color
	game_state = state
	health.max_health = character.starting_hp
	for status in character.starting_traits:
		status_effects.add_new_status(status)


## This method is mandatory for creatures having a [HurtBox].
## [param damage] is the amount of damage to take.
func take_damage(damage: int) -> void:
	_create_floating_text("-%s" % damage, Color.RED)
	animation_player.play("damage")
	health.health -= damage


## This method is for healing the player
## [param amount] is the amount of health restored.
func heal(amount: int) -> void:
	_create_floating_text("+%s" % amount, Color.GREEN)
	animation_player.play("heal")
	health.health += amount


## Changes the maximum health of the player.
## [param amount] is the amount of change.
func change_max_health(amount: int) -> void:
	health.max_health += amount


## Returns the position where ranged [Enemy] units
## should shoot their projectiles.
func get_ranged_target_position() -> Vector2:
	return ranged_target_position.global_position


## Spawns a projectile at the end of the staff.
## This is mainly used by [Effect]s.
## [param target] is the target of the spell,
## [param projectile] is PackedScene of the projectile to spawn.
## [param start] is the starting point of the projectile. If it's (0, 0)
## the spell is cast from the player's staff
func spawn_projectile(target: Vector2, projectile: PackedScene, start: Vector2 = Vector2.ZERO) -> void:
	var from: Vector2 = start if start != Vector2.ZERO else staff_end.global_position
	var new_projectile := projectile.instantiate()
	get_tree().root.add_child(new_projectile)
	new_projectile.global_position = from
	new_projectile.launch(target, bonus_damage.get_modifier())


## Creates a floating text for the player.
## [param text] is the text of the message.
## [param color] is the [Color].
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


## Called when the player's health changes.
## [param new_hp] is the new health of the player.
func _on_health_changed(new_hp: int) -> void:
	health_bar.update_health.call_deferred(new_hp)


## Called when the player's health reaches zero.
func _on_health_reached_zero() -> void:
	if not game_state.is_paused():
		Events.game_over.emit()
		game_state.change_to(GameState.State.PAUSED)


## Play spell animation when an [Effect] is created.
## If it's a SELF-targeted effect, also apply it to the player character.
func _on_effect_created(effect: Effect) -> void:
	if not effect or not animation_player.has_animation(effect.anim_name):
		return
	
	animation_player.play(effect.anim_name)
	await animation_player.animation_finished
	
	if effect.target_type == Effect.TargetType.SELF:
		effect.setup([self])
		await effect.apply_effect()
		return
	
	if effect.anim_name == "cast_spell_ground":
		animation_player.play_backwards("cast_spell_ground")
	else:
		animation_player.play("cast_spell_finish")
	await animation_player.animation_finished
	
	animation_player.play("idle")


## If the player is tapped on, show their statuses if there are any.
func _on_hurt_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("tap"):
		Events.status_tooltip_requested.emit(status_effects.get_all_status_data(), self)
