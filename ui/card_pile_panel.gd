## This panel shows a set of [Card]s in a grid.
## This is used to display the [Player]'s deck, draw pile and discard pile.
extends CenterContainer

signal closed

## [GameState] dependency.
@export var game_state: GameState
@onready var panel_title: Label = %PanelTitle
@onready var card_grid: GridContainer = %CardGrid
@onready var close_button: Button = %CloseButton
@onready var card_view := preload("res://ui/card_view.tscn")
@onready var scroll_container: ScrollContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer


func _ready() -> void:
	_clear_children()
	close_button.pressed.connect(fade_out)
	scroll_container.get_v_scroll_bar().scrolling.connect(_on_scroll_container_scroll_started)


## Clears any previous cards in the pile.
func _clear_children() -> void:
	for c in card_grid.get_children():
		c.queue_free()


## Shows the Card Pile panel.
## [param title] is the title used for this view. (e.g. Draw Pile)
## [param cards] is the array of [CardData], i.e. the Cards to show.
## [param character] is the curernt [Character].
func show_panel(title: String, cards: Array[CardData], character: Character) -> void:
	game_state.change_to(GameState.State.PAUSED)
	close_button.disabled = true
	panel_title.text = title
	_clear_children()
	
	var unique_cards := _get_unique_cards_counted(cards)
	
	for card in unique_cards:
		var new_card_view := card_view.instantiate()
		card_grid.add_child(new_card_view)
		new_card_view.setup(card, character, unique_cards[card])
	
	fade_in()


## Animates the Panel fading in.
func fade_in() -> void:
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback(show)
	t.parallel().tween_property(self, "position", Vector2.ZERO, 0.3).from(Vector2(0, 35))
	t.parallel().tween_property(self, "modulate", Color.WHITE, 0.4).from(Color.TRANSPARENT)
	t.tween_callback(close_button.set.bind("disabled", false))


## Animates the Panel fading out.
func fade_out() -> void:
	close_button.disabled = true
	closed.emit()
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", Vector2(0, 35), 0.3)
	t.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
	t.tween_callback(hide)
	t.tween_callback(game_state.change_to.bind(GameState.State.PLAYING))


## Returns a [Dictionary] of unique cards with their number of occurances.
## Key: card ([CardData]), Value: number of occurances (int)
func _get_unique_cards_counted(cards: Array[CardData]) -> Dictionary:
	var unique_cards := {}
	
	for card in cards:
		if card in unique_cards:
			continue
		
		unique_cards[card] = cards.count(card)
	
	return unique_cards


## We hide tooltips when the [Player] starts scrolling.
func _on_scroll_container_scroll_started() -> void:
	Events.card_tooltip_requested.emit(null, null)
