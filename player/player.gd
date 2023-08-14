## Class representing the Player character.
class_name Player
extends Sprite2D


@onready var health: Health = $Health
@onready var health_bar: PanelContainer = $HealthBar


func _ready() -> void:
	health.changed.connect(
		func(new_hp): health_bar.update_health.call_deferred(new_hp)
	)
	health.max_health_changed.connect(health_bar.setup)


## This method is mandatory for creatures having a [Hurtbox].
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
