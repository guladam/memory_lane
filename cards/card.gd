## Represents a physical, clickable card on the 
## game board.
class_name Card
extends Area2D

## [CardData] resource.
@export var card: CardData: set = _set_card
## A boolean for checking if the card is flipped over.
@onready var is_flipped := false
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var back: Sprite2D = $Back
@onready var front: CardFront = $Back/CardFront
@onready var match_sound: AudioStreamPlayer = $MatchSound


## Flips the card. It's a coroutine as it waits for the animation
## to finish.
func flip() -> void:
	if is_flipped or anim_player.is_playing():
		return
	
	input_pickable = false
	anim_player.play("flip")
	match_sound.play()
	Events.card_flip_started.emit(self)
	
	await anim_player.animation_finished
	
	is_flipped = true
	Events.card_flipped.emit(self)


## Flips the card back. It's a coroutine 
## as it waits for the animation to finish.
func unflip() -> void:
	if not is_flipped or anim_player.is_playing():
		return

	anim_player.play("unflip")
	Events.card_unflip_started.emit(self)
	
	await anim_player.animation_finished
	
	Events.card_unflipped.emit(self)
	is_flipped = false
	input_pickable = true


## Tween animation when a card is drawn.
## This method is a coroutine as it waits for the tween animation to complete.
## [param from] is the position of the draw pile, [param to] is the final position of the card.
func animate_draw(from: Vector2, to: Vector2) -> void:
	Events.card_draw_started.emit(self)
	
	global_position = from
	rotation_degrees = 90
	scale = Vector2(0.5, 0.5)
	
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "global_position", to, 0.3)
	t.parallel().tween_property(self, "rotation_degrees", 0, 0.15)
	t.parallel().tween_property(self, "scale", Vector2.ONE, 0.15)
	t.tween_callback(func(): Events.card_drawn.emit(self))
	await t.finished


## Tween animation when a card is matched with its pair.
## This method is a coroutine as it waits for the tween animation to complete.
## [param pair_position] is the position of the matching pair.
## [param discard_position] is the position of the Discard Pile.
func animate_match(pair_position: Vector2, discard_position: Vector2) -> void:
	## TODO this way this is fired twice
	Events.card_match_started.emit(self)
	var target_pos: Vector2 = global_position.lerp(pair_position, 0.5)
	z_index = 99
	
	var t := create_tween()
	t.tween_property(self, "global_position", target_pos, 0.2)
	t.parallel().tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
	t.parallel().tween_callback(func():
		Events.board_particle_requested.emit(target_pos)
	)
	t.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2(1.5, 1.5), 0.6)
	t.tween_interval(0.35)
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "global_position", discard_position, 0.3)
	t.parallel().tween_property(self, "scale", Vector2(0.5, 0.5), 0.3)
	t.parallel().tween_property(self, "rotation_degrees", 90.0, 0.3)
	t.tween_callback(func(): Events.card_matched.emit(self))
	await t.finished


## Tween animation when a card is discarded.
## This method is a coroutine as it waits for the tween animation to complete.
## [param discard_position] is the position of the Discard Pile.
func animate_discard(discard_position: Vector2) -> void:
	Events.card_discard_started.emit(self)
	
	z_index = 99
	
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "global_position", discard_position, 0.3)
	t.parallel().tween_property(self, "scale", Vector2(0.5, 0.5), 0.3)
	t.parallel().tween_property(self, "rotation_degrees", 90.0, 0.3)
	t.tween_callback(func(): Events.card_discarded.emit(self))
	await t.finished
	queue_free()


## Reveals the card. It's a coroutine as it waits for the animation
## to finish.
func animate_reveal() -> void:
	print("reveal this!")
	if is_flipped or anim_player.is_playing():
		return
	
	input_pickable = false
	anim_player.play("reveal")
	await anim_player.animation_finished
	anim_player.play("unflip")
	await anim_player.animation_finished
	input_pickable = true


## Injects all data and dependencies when creating a new card.
func setup(new_card_data: CardData, character: Character) -> void:
	self.card = new_card_data
	match_sound.pitch_scale = new_card_data.pitch
	match_sound.stream = new_card_data.card_sound
	front.setup(new_card_data, character)


## Sets the data of the card to [param new_card_data].
func _set_card(new_card_data: CardData) -> void:
	if not is_inside_tree():
		await ready
	
	card = new_card_data
	back.texture = new_card_data.card_back


func _to_string() -> String:
	return "%s_%s" % [card.id, get_index()]
