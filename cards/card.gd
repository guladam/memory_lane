## Represents a physical, clickable card on the 
## game board.
class_name Card
extends Area2D

## [CardData] resource.
@export var card: CardData: set = _set_card
@onready var is_flipped := false
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var back: Sprite2D = $Back
@onready var front: Sprite2D = $Back/Front

## Flips the card. It's a coroutine as it waits for the animation
## to finish.
func flip() -> void:
	if is_flipped or anim_player.is_playing():
		return
	
	input_pickable = false
	anim_player.play("flip")
	Events.card_flip_started.emit(self)
	
	await anim_player.animation_finished
	
	Events.card_flipped.emit(self)
	is_flipped = true


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
	z_index = 99
	
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "global_position", global_position.lerp(pair_position, 0.5), 0.2)
	t.parallel().tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
	## TODO something fancy
	t.tween_interval(0.25)
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


## Sets the data of the card to [param new_card_data].
func _set_card(new_card_data: CardData) -> void:
	if not is_inside_tree():
		await ready
	
	card = new_card_data
	back.texture = new_card_data.card_back
	front.texture = new_card_data.card_front


func _to_string() -> String:
	return "%s_%s" % [card.id, get_index()]
