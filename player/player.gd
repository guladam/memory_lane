## Class representing the Player character.
class_name Player
extends Sprite2D


@onready var health: Health = $Health
@onready var health_bar: PanelContainer = $HealthBar
@onready var ranged_target_position: Marker2D = $RangedTargetPosition


func _ready() -> void:
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


## Called when the player's health changes.
## [param new_hp] is the new health of the player.
func _on_health_changed(new_hp: int) -> void:
	health_bar.update_health.call_deferred(new_hp)
	if new_hp <= 0:
		Events.game_over.emit()
