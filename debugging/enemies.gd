extends HBoxContainer


@export var enemy_manager: EnemyManager


func _on_enemy_turn_pressed() -> void:
	enemy_manager.do_enemy_turn()
