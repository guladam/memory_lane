## A character which can be selected to play with.
extends PanelContainer

## Emitted when the character is selected.
signal selected(character: Character)

## The [Character] represented by this UI element.
@export var character: Character

@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	name_label.text = character.name
	icon.texture = character.icon


## Deselects the character.
func deselect() -> void:
	print("deselected %s" % name_label.text)


## Selects the character.
func select() -> void:
	print("selected %s" % name_label.text)


## Selects the character when its clicked.
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		select()
		selected.emit(character)
