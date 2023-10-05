extends Node


@export var effect: PackedScene
@export var target_node: Node2D


func spawn_effect() -> void:
	var new_effect := effect.instantiate()
	get_tree().root.add_child(new_effect)
	new_effect.global_position = target_node.global_position
