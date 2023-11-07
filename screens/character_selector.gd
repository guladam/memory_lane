## This screen shows the [Player] starts a new game.
extends Control


## Emitted when the player wants to go back to the main menu.
signal main_menu_requested
## Emitted when the player wants to start a new game with the
## selected [Character].
signal new_game_requested(character: Character)

@export var default_sound: AudioStream

@onready var play: Button = %Play
@onready var back: Button = %Back
@onready var pickable_characters: HBoxContainer = %PickableCharacters
@onready var picked_character_info: Label = %PickedCharacterInfo
@onready var shine: ColorRect = %Shine

var picked_character: Character
var t: Tween


func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit(picked_character))
	back.pressed.connect(func(): main_menu_requested.emit())
	
	for pc in pickable_characters.get_children():
		pc.selected.connect(_on_pickable_character_selected)
		pc.selected_locked_character.connect(_on_locked_character_selected)


## Enables or disables both buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	back.disabled = not enabled


func initialize() -> void:
	pickable_characters.get_child(0).select()
	picked_character = pickable_characters.get_child(0).character
	SfxPlayer.play(picked_character.select_sound, true)


## Fades out the icons with their shaders
func fade_out_icons() -> void:
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tw = tw.set_parallel()
	for pc in pickable_characters.get_children():
		tw.tween_property(pc.icon.material, "shader_parameter/alpha", 0.0, 1.0)


## Animates the shine shader on the screen.
## Uses color based on a [param character].
func _shine_character(character: Character) -> void:
	if t and t.is_running():
		t.kill()
	
	shine.material.set_shader_parameter("shine_color", character.color)
	shine.material.set_shader_parameter("shine_progress", 0.0)
	t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(shine.material, "shader_parameter/shine_progress", 1.0, 0.7)


## Deselects all available [Character]s, except for one
## [param exception].
func _deselect_other_characters(exception: Character) -> void:
	for pc in pickable_characters.get_children():
		if pc.character != exception:
			pc.deselect()


## Called when the player selects a playable [Character] on this screen.
func _on_pickable_character_selected(character: Character) -> void:
	_deselect_other_characters(character)
	play.disabled = false
	if visible:
		SfxPlayer.play(character.select_sound, true)
	
	picked_character = character
	picked_character_info.text = character.tooltip
	_shine_character(character)


## Called when the player selects a locked [Character] on this screen.
func _on_locked_character_selected(character: Character) -> void:
	_deselect_other_characters(character)
	play.disabled = true
	
	var msg: String
	match character.name:
		"Ice":
			msg = "Beat Level 6 to unlock this element!"
		"Earth":
			msg = "Beat the game to unlock this element!"
		_:
			msg = " "
	
	picked_character_info.text = msg
	
