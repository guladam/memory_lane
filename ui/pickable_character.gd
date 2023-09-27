## A character which can be selected to play with.
extends PanelContainer

## Emitted when the character is selected.
signal selected(character: Character)
## Emitted when the character is selected but locked.
signal selected_locked_character(character: Character)


## The [Character] represented by this UI element.
@export var character: Character

@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel
var unlocked: bool


func _ready() -> void:
	name_label.text = character.name
	icon.texture = character.icon
	self_modulate = Color.TRANSPARENT
	unlocked = character.is_unlocked()
	
	if not unlocked:
		icon.material.set_shader_parameter("enabled", 1)


## Deselects the character.
func deselect() -> void:
	self_modulate = Color.TRANSPARENT


## Selects the character.
func select() -> void:
	if not unlocked:
		return
	
	selected.emit(character)
	self_modulate = character.color


## Selects the character when its clicked.
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("tap"):
		if unlocked:
			select()
		else:
			selected_locked_character.emit(character)
