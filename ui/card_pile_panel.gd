## This panel shows a set of [Card]s in a grid.
## This is used to display the [Player]'s deck, draw pile and discard pile.
extends CenterContainer

## [GameState] dependency.
@export var game_state: GameState
@onready var panel_title: Label = %PanelTitle
@onready var card_grid: GridContainer = %CardGrid
@onready var close_button: Button = %CloseButton
@onready var card_view := preload("res://ui/card_view.tscn")


func _ready() -> void:
	_clear_children()
	close_button.pressed.connect(fade_out)


## Clears any previous cards in the pile.
func _clear_children() -> void:
	for c in card_grid.get_children():
		c.queue_free()


## Shows the Card Pile panel.
## [param title] is the title used for this view. (e.g. Draw Pile)
## [param cards] is the array of [CardData], i.e. the Cards to show.
func show_panel(title: String, cards: Array[CardData]) -> void:
	game_state.change_to(GameState.State.PAUSED)
	close_button.disabled = true
	panel_title.text = title
	_clear_children()
	
	for card in cards:
		var new_card_view := card_view.instantiate()
		card_grid.add_child(new_card_view)
		new_card_view.setup(card)
		new_card_view.tooltip_shown.connect(_on_card_tooltip_shown)
	
	fade_in()


## Animates the Panel fading in.
func fade_in() -> void:
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback(show)
	t.parallel().tween_property(self, "position", Vector2.ZERO, 0.5).from(Vector2(0, 75))
	t.parallel().tween_property(self, "modulate", Color.WHITE, 0.75).from(Color.TRANSPARENT)
	t.tween_callback(close_button.set.bind("disabled", false))


## Animates the Panel fading out.
func fade_out() -> void:
	close_button.disabled = true
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", Vector2(0, 75), 0.75)
	t.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	t.tween_callback(hide)
	t.tween_callback(game_state.change_to.bind(GameState.State.PLAYING))


## This is called when a tooltip is shown for a card.
## [param _card_view] is the card that has its tooltip shown.
func _on_card_tooltip_shown(_card_view: Control) -> void:
	for card in card_grid.get_children():
		if card != _card_view:
			card.turn_off_tooltip()
