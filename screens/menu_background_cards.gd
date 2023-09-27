## Animates random cards flipping and unflipping in the background.
extends CanvasGroup


@export var characters: Array[Character]
@export var card_fronts: Array[CardData]

@onready var empty_bg := preload("res://cards/card_back_empty.png")
@onready var cards := self.get_children()
@onready var timer: Timer = $Timer
@onready var flipping := true


func _ready() -> void:
	randomize()
	cards.pop_back()
	if DisplayServer.screen_get_size().y > 1920:
		position.y = (DisplayServer.screen_get_size().y - 1920) / 2.0
	
	for c in cards:
		c.setup(card_fronts.pick_random(), characters.pick_random())
		c.back.texture = empty_bg
	
	timer.wait_time = randf_range(3.0, 6.0)
	timer.start()


func _on_timer_timeout() -> void:
	var flipped := cards.filter(func(c: Card): return c.is_flipped).size()
	flipping = flipping and flipped < 12
	
	# Get back to flipping when all cards are unflipped.
	if not flipping and flipped == 0:
		flipping = true
	
	if flipping:
		_flip_two_random()
	else:
		_unflip_two_random()


## Flips two random cards with a small delay.
func _flip_two_random() -> void:
	var unflipped_cards := cards.filter(func(c: Card): return not c.is_flipped)
	var card1: Card = unflipped_cards.pick_random()
	var card2 := card1
	
	while card1 == card2:
		card2 = unflipped_cards.pick_random()
		
	card1.flip()
	await get_tree().create_timer(0.3).timeout
	card2.flip()


## Unflips two random cards with a small delay.
func _unflip_two_random() -> void:
	var flipped_cards := cards.filter(func(c: Card): return c.is_flipped)
	var card1: Card = flipped_cards.pick_random()
	var card2 := card1
	
	while card1 == card2:
		card2 = flipped_cards.pick_random()
		
	card1.unflip()
	await get_tree().create_timer(0.3).timeout
	card2.unflip()
