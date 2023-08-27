extends VBoxContainer


signal main_menu_requested
signal new_game_requested(character: Character)

@onready var play: Button = %Play
@onready var back: Button = %Back
@onready var pickable_characters: HBoxContainer = %PickableCharacters

var picked_character: Character


func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit(picked_character))
	back.pressed.connect(func(): main_menu_requested.emit())
	
	for pc in pickable_characters.get_children():
		pc.selected.connect(_on_pickable_character_selected)
	
	pickable_characters.get_child(0).select()
	picked_character = pickable_characters.get_child(0).character


func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	back.disabled = not enabled


func _on_pickable_character_selected(character: Character) -> void:
	for pc in pickable_characters.get_children():
		if pc.character != character:
			pc.deselect()
	
	picked_character = character
