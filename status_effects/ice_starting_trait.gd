## A status effect which adds 1 Frost,
## to a random [Enemy], when the player discards a pair of cards, or empties the board.
extends Status

var frost_status := preload("res://status_effects/frost_1_data.tres")
var frost_vfx := preload("res://weapons/frost_vfx.tscn")
var first_turn := true
var _icon_texture: Texture
var player: Node

## This overrides the virtual method [method Status.apply_status].
## [param _target] is the receiving unit.
func apply_status(target: Node) -> void:
	if first_turn:
		Events.board_emptied.connect(_on_board_emptied)
		Events.pairs_discarded.connect(_on_pairs_discarded)
		player = target
		first_turn = false
	
	status_applied.emit()


func _on_board_emptied() -> void:
	if player:
		_icon_texture = Status.ICONS[self.data.icon]
		player.create_status_highlight(_icon_texture)
	_add_frost()


func _on_pairs_discarded(n: int) -> void:
	if player:
		_icon_texture = Status.ICONS[self.data.icon]
		player.create_status_highlight(_icon_texture)
	for i in range(n):
		_add_frost()


func _add_frost() -> void:
	print("request 1 random frost")
	Events.add_status_to_random_enemy_requested.emit(frost_status.duplicate(), frost_vfx, _icon_texture)
