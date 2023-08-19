extends HBoxContainer


@export var enemy_manager: EnemyManager
@onready var enemy_index: SpinBox = $EnemyIndex


func _on_enemy_turn_pressed() -> void:
	enemy_manager.do_enemy_turn()


func _on_enemy_damage_pressed() -> void:
	enemy_manager.damage_unit(int(enemy_index.value))
