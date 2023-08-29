extends TextureRect

signal selected(card: CardData)


var card: CardData


func setup(_card: CardData) -> void:
	card = _card
	texture = card.card_front


func deselect() -> void:
	print("deselected %s" % card.id)


func select() -> void:
	print("selected %s" % card.id)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		select()
		selected.emit(card)
