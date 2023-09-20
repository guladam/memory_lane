## Holds all the [Card]s currently visible to the player.
class_name Board
extends Node2D


## [GameState] dependency.
@export var game_state: GameState
## This array is representing the current [Card]s.
@onready var current_cards := []
## This array is tracking the currently flipped [Card](s).
@onready var flipped_cards := []
## Tracks if the board is interactable.
## This is used to prevent flipping [Card]s over 
## while animating or during the enemy's turn.
@onready var interactable := true
## [Card] scene used for spawning the cards in place.
@onready var card_scene := preload("res://cards/card.tscn")
## Node holding the spawn position markers for the [Card]s.
@onready var card_markers: Array[Node] = $CardMarkers.get_children()
## Node holding [Card]s.
@onready var cards: Node2D = $Cards
## Position of the draw pile. Needed for [Card] animations.
var draw_pile_pos: Vector2
## Position of the discard pile. Needed for [Card] animations.
var discard_pile_pos: Vector2
## [Character] dependency for spawning [Card]s.
var current_character: Character


func _ready() -> void:
	Events.effect_created.connect(_on_effect_created)
	Events.card_flip_started.connect(_on_card_flip_started)
	Events.card_flipped.connect(_on_card_flipped)
	Events.card_unflipped.connect(_on_card_unflipped)

	Events.player_turn_started.connect(_on_player_turn_started)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	Events.board_reveal_requested.connect(reveal_cards)


## This method is used for dependency injection.
## The board needs the position of the draw and discard piles for 
## [Card] animations.
func setup(_draw_pile_pos: Vector2, _discard_pile_pos: Vector2, character: Character) -> void:
	draw_pile_pos = _draw_pile_pos
	discard_pile_pos = _discard_pile_pos
	current_character = character
	
	current_cards.resize(12)
	current_cards.fill(null)


## Spawns [Card]s in place based on an array of [CardData].
## This is a coroutine because it waits for the last card draw 
## animation to finish.
func spawn_cards(new_cards: Array[CardData]) -> void:
	interactable = false
	
	for i in range(new_cards.size()):
		var j = i
		while _is_space_occupied(j) and j < current_cards.size():
			j += 1
		
		var new_card = card_scene.instantiate()
		cards.add_child(new_card)
		new_card.setup(new_cards[i], current_character)
		new_card.input_event.connect(_on_card_input_event.bind(new_card))
		current_cards[j] = new_card
		
		if i < new_cards.size()-1:
			new_card.animate_draw(draw_pile_pos, card_markers[j].global_position)
			await get_tree().create_timer(0.15).timeout
		else:
			await new_card.animate_draw(draw_pile_pos, card_markers[j].global_position)
	
	# TODO feels hacky
	if get_current_board_card_number() == 12:
		interactable = true


## Discards the entire current board.
func discard_board() -> void:
	var last_card := _get_last_card_index()
		
	# If the board is already empty, we can return
	if last_card == -1:
		return
	
	interactable = false
	
	for i in range(current_cards.size()):
		if not _is_space_occupied(i):
			continue
			
		var card = current_cards[i]
		if card and is_instance_valid(card):
			if i != last_card:
				card.animate_discard(discard_pile_pos)
				await get_tree().create_timer(0.15).timeout
			else:
				await card.animate_discard(discard_pile_pos)
	
	current_cards.fill(null)
	Events.board_emptied.emit()


## Reveals [param num_of_cards] [Card]s to the [Player].
func reveal_cards(num_of_cards: int) -> void:
	interactable = false
	var picked_cards := _get_random_cards(num_of_cards)
	
	for i in range(picked_cards.size()):
		print("reveal %s, card: %s" % [i, picked_cards[i].card.id])
		
		if i == num_of_cards - 1:
			await picked_cards[i].animate_reveal()
		else:
			picked_cards[i].animate_reveal()
	
	interactable = true


## Returns the number of cards on the board.
func get_current_board_card_number() -> int:
	var non_empty_elements = current_cards.filter(func(card): return card != null)
	return non_empty_elements.size()


## Returns [param n] random [Card]s from the board.
func _get_random_cards(n: int) -> Array[Card]:
	var picked_cards: Array[Card] = []
	
	if get_current_board_card_number() < n:
		print("you need at least %s cards to get!" % n)
		return picked_cards
	
	while picked_cards.size() < n:
		var card: Card = current_cards.pick_random()
		if card and not picked_cards.has(card):
			picked_cards.append(card)
			
	return picked_cards


## Returns [code]true[/code] if the [param n]th space is occupied.
func _is_space_occupied(n) -> bool:
	return current_cards[n] != null


## Returns [code]true[/code] if the board is currently empty.
func _is_board_empty() -> bool:
	return get_current_board_card_number() == 0


## Returns the index of the last [Card] on the board.
func _get_last_card_index() -> int:
	var last_card := current_cards.size() - 1
	while not _is_space_occupied(last_card) and last_card > 0:
		last_card -= 1
		
	return last_card


## Returns [code]true[/code] if there is a match made on the board.
func _is_match() -> bool:
	if flipped_cards.size() != 2:
		return false
	
	return flipped_cards[0].card.is_matching(flipped_cards[1].card)


## Checks the current flipped pair of [Card]s on the board.
func _check_pair() -> void:
	if _is_match():
		_on_match()
	else:
		_on_mismatch()


## Called when there is a matched pair of [Card]s on the board.
func _on_match() -> void:
	flipped_cards[0].animate_match(flipped_cards[1].global_position, discard_pile_pos)
	await flipped_cards[1].animate_match(flipped_cards[0].global_position, discard_pile_pos)
	
	current_cards[current_cards.find(flipped_cards[0])] = null
	current_cards[current_cards.find(flipped_cards[1])] = null
	
	Events.effect_created.emit(flipped_cards[0].card.effect)
	
	flipped_cards[0].queue_free()
	flipped_cards[1].queue_free()
	flipped_cards.clear()
	
	if _is_board_empty():
		Events.board_emptied.emit()


## Called when two different [Card]s are flipped over.
func _on_mismatch() -> void:
	interactable = false
	Events.cards_mismatched.emit()
	await flipped_cards[0].unflip()
	await flipped_cards[0].unflip()
	Events.player_turn_ended.emit()


## Called when the [Card]s are clicked. The cards can't handle
## this event by themselves because we need to make sure that
## no more than 2 cards are flipped at any given time.
func _on_card_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, card: Card) -> void:
	var two_cards_flipped := flipped_cards.size() == 2
	var is_paused := game_state.is_paused()
	
	if two_cards_flipped or is_paused or (not interactable):
		return

	if event is InputEventMouseButton and event.is_pressed():
		card.flip()


## Called when a [Card] is started flipping over.
func _on_card_flip_started(card: Card) -> void:
	flipped_cards.append(card)


## Called when a [Card] is flipped over.
func _on_card_flipped(_card: Card) -> void:
	if flipped_cards.size() == 2:
		_check_pair()


## Called when a [Card] is flipped back.
func _on_card_unflipped(card: Card) -> void:
	flipped_cards.erase(card)


## Called when an [Effect] is created by matching 2 [Card]s.
func _on_effect_created(effect: Effect) -> void:
	if not effect:
		return
	
	if effect.target_type != Effect.TargetType.BOARD:
		return
	
	effect.setup([self])
	effect.apply_effect()


## Called when it's the [Player]'s turn.
func _on_player_turn_started() -> void:
	self.interactable = true
	self.modulate.a = 1.0


## Called when the [Player]'s turn is over.
func _on_player_turn_ended() -> void:
	self.interactable = false
	self.modulate.a = 0.5
