## A status effect which heals the [Player] for 1
## when the owning unit is damaged.
extends Status

var first_turn := true
var enemy: Enemy
var player: Player

## This overrides the virtual method [method Status.apply_status].
## [param target] is the receiving unit.
func apply_status(target: Node) -> void:
	if first_turn:
		enemy = target as Enemy
		player = get_tree().get_first_node_in_group("player") as Player
		player.damaged.connect(_on_player_damaged)
		first_turn = false
	elif duration == 0 and enemy:
		player.damaged.disconnect(_on_player_damaged)
		
	status_applied.emit()
	super.apply_status(target)


func _on_player_damaged(damage: int) -> void:
	if enemy:
		enemy.take_damage(damage)
