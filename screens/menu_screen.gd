## This screen manages and animates all the different available
## screens in the game's starting menu.
extends ColorRect

## Emitted when the player starts a new game with the selected [Character].
signal start_new_game(character: Character)

@onready var main_menu: VBoxContainer = $MainMenu
@onready var character_selector: VBoxContainer = $CharacterSelector
@onready var credits: VBoxContainer = $Credits


func _ready() -> void:
	main_menu.credits_requested.connect(
		func():
			_fade_out_left(main_menu)
			_fade_in_right(credits)
	)
	main_menu.new_game_requested.connect(
		func():
			_fade_out_left(main_menu)
			_fade_in_right(character_selector)
	)
	
	character_selector.main_menu_requested.connect(
		func():
			_fade_out_right(character_selector)
			_fade_in_left(main_menu)
	)
	character_selector.new_game_requested.connect(
		func(character: Character):
			await _fade_out_front(character_selector)
			start_new_game.emit(character)
	)
	
	credits.main_menu_requested.connect(
		func():
			_fade_out_right(credits)
			_fade_in_left(main_menu)
	)


## Fade out left animation used by other screens.
## This is a coroutine as it waits for the animation to finish playing.
## [param screen] is the screen [Control] node which needs to be animated.
func _fade_out_left(screen: Control) -> void:
	screen.set_buttons(false)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(screen, "position:x", -500, 0.6)
	t.parallel().tween_property(screen, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(screen.hide)
	await t.finished


## Fade in left animation used by other screens.
## This is a coroutine as it waits for the animation to finish playing.
## [param screen] is the screen [Control] node which needs to be animated.
func _fade_in_left(screen: Control) -> void:
	screen.set_buttons(false)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback(screen.show)
	t.tween_property(screen, "position:x", 70, 0.5).from(-500)
	t.parallel().tween_property(screen, "modulate", Color.WHITE, 0.6)
	await t.finished
	screen.set_buttons(true)


## Fade out right animation used by other screens.
## This is a coroutine as it waits for the animation to finish playing.
## [param screen] is the screen [Control] node which needs to be animated.
func _fade_out_right(screen: Control) -> void:
	screen.set_buttons(false)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(screen, "position:x", 500, 0.6)
	t.parallel().tween_property(screen, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(screen.hide)
	await t.finished


## Fade in right animation used by other screens.
## This is a coroutine as it waits for the animation to finish playing.
## [param screen] is the screen [Control] node which needs to be animated.
func _fade_in_right(screen: Control) -> void:
	screen.set_buttons(false)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback(screen.show)
	t.tween_property(screen, "position:x", 70, 0.5).from(500)
	t.parallel().tween_property(screen, "modulate", Color.WHITE, 0.6)
	await t.finished
	screen.set_buttons(true)


## Fade out front animation used by other screens.
## This is a coroutine as it waits for the animation to finish playing.
## [param screen] is the screen [Control] node which needs to be animated.
func _fade_out_front(screen: Control) -> void:
	screen.set_buttons(false)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(screen, "scale", Vector2(1.5, 1.5), 1.2)
	t.parallel().tween_property(screen, "modulate", Color.TRANSPARENT, 1.0)
	t.tween_callback(screen.hide)
	await t.finished
