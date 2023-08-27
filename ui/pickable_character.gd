extends PanelContainer

signal selected(character: Character)

@export var character: Character
@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	name_label.text = character.name
	icon.texture = character.icon


func deselect() -> void:
	print("deselected %s" % name_label.text)


func select() -> void:
	print("selected %s" % name_label.text)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		select()
		selected.emit(character)
