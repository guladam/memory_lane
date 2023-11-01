## A status effect which damages a random [Enemy] for 1,
## when the [Player] overheals themselves.
extends Status

var overheal_vfx := preload("res://weapons/overheal_vfx.tscn")
var first_turn := true
var _icon_texture: Texture
var player: Node

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	if first_turn:
		Events.player_overhealed.connect(_on_player_overhealed)
		player = target
		first_turn = false
	
	status_applied.emit()


func _on_player_overhealed() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if not player or enemies.is_empty():
		return
	
	_icon_texture = Status.ICONS[self.data.icon]
	player.create_status_highlight(_icon_texture)
	
	var enemy: Enemy = enemies.pick_random() as Enemy
	var new_vfx := overheal_vfx.instantiate()
	new_vfx.global_position = enemy.global_position
	get_tree().root.add_child(new_vfx)
	enemy.take_damage(1)
