extends HBoxContainer

@export var player: Player

func _on_player_dmg_pressed() -> void:
	player.take_damage(1)


func _on_player_heal_pressed() -> void:
	player.heal(1)


func _on_player_max_high_pressed() -> void:
	player.change_max_health(1)


func _on_player_max_low_pressed() -> void:
	player.change_max_health(-1)
