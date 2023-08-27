## Class representing the Player character.
class_name Player
extends Sprite2D


@onready var health: Health = $Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var ranged_target_position: Marker2D = $RangedTargetPosition
@onready var staff_end: Marker2D = $Staff/StaffEnd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bonus_damage: Modifiers = $BonusDamage
@onready var status_effects: StatusEffects = $StatusEffects


func _ready() -> void:
	Events.effect_created.connect(_on_effect_created)
	health.changed.connect(_on_health_changed)
	health.max_health_changed.connect(health_bar.setup)
	
	health_bar.setup(health.max_health)


## This method is mandatory for creatures having a [HurtBox].
## [param damage] is the amount of damage to take.
func take_damage(damage: int) -> void:
	health.health -= damage


## This method is for healing the player
## [param amount] is the amount of health restored.
func heal(amount: int) -> void:
	health.health += amount


## Changes the maximum health of the player.
## [param amount] is the amount of change.
func change_max_health(amount: int) -> void:
	health.max_health += amount


## Returns the position where ranged [Enemy] units
## should shoot their projectiles.
func get_ranged_target_position() -> Vector2:
	return ranged_target_position.global_position


## PLays the correct spell animation, based on the target type.
## This is mainly used by [Effect]s.
## [param target_type] is the spell's target type,
## [param backwards] is a boolean parameter for playing the animation backwards.
func play_spell_animation(target_type: Effect.TargetType, backwards: bool = false) -> void:
	var method := "play_backwards" if backwards else "play"
	var anim_name: String
	
	match target_type:
		Effect.TargetType.GROUND:
			anim_name = "cast_spell_ground"
		Effect.TargetType.AIR:
			anim_name = "cast_spell_air"
		_:
			anim_name = "cast_spell_other"
	
	animation_player.call(method, anim_name)
	await animation_player.animation_finished


## Spawns a projectile at the end of the staff.
## This is mainly used by [Effect]s.
## [param target] is the target of the spell,
## [param projectile] is PackedScene of the projectile to spawn.
func spawn_projectile(target: Vector2, projectile: PackedScene) -> void:
	var new_projectile := projectile.instantiate()
	get_tree().root.add_child(new_projectile)
	new_projectile.global_position = staff_end.global_position
	new_projectile.launch(target, bonus_damage.get_modifier())


## Called when the player's health changes.
## [param new_hp] is the new health of the player.
func _on_health_changed(new_hp: int) -> void:
	health_bar.update_health.call_deferred(new_hp)
	if new_hp <= 0:
		Events.game_over.emit()
		print("game over")



## Inject the [Player] as a dependency when an [Effect] is created.
func _on_effect_created(effect: Effect) -> void:
	if not effect:
		return
		
	effect.set_player(self)
	print("player dependency injected")
