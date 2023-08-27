extends PanelContainer


@export var board: Board


func _input(event: InputEvent) -> void:
	if not OS.has_feature("editor"):
		return
	
	if event.is_action_pressed("hide_debug_window"):
		visible = not visible


func _on_show_board_pressed() -> void:
	var print_string: PackedStringArray = []
	for i in range(board.current_cards.size()):
		var card := "empty"
		if board.current_cards[i]:
			card = board.current_cards[i].to_string()
		if i % 4 == 3:
			print_string.append(card + "\n\n")
		else:
			print_string.append(card + "\t\t")
			
	print("".join(print_string))
