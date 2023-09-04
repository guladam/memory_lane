## This screen is shown when a [Level] is won and the [Player]
## can draft new [Card]s to their [Deck].
extends ColorRect

## Emitted when the user has selected a card to draft, or when they
## skipped the reward.
signal card_drafted(new_card: CardData)

@onready var add: Button = %Add
@onready var skip: Button = %Skip
@onready var cards: HBoxContainer = %Cards
@onready var draftable_card := preload("res://ui/draftable_card.tscn")

var picked_card: CardData


func _ready() -> void:
	add.pressed.connect(func(): card_drafted.emit(picked_card))
	skip.pressed.connect(func(): card_drafted.emit(null))


## This method sets the screen up before showing it.
## [param run] is the data for the current [Run].
func setup(run: Run) -> void:
	var rewards := run.character.available_cards.duplicate(true)
	rewards.shuffle()
	rewards = rewards.slice(0, 3)
	
	for card in rewards:
		var new_draftable_card := draftable_card.instantiate()
		cards.add_child(new_draftable_card)
		new_draftable_card.setup(card)
		new_draftable_card.selected.connect(_on_card_selected)
	
	cards.get_child(0).select()
	picked_card = cards.get_child(0).card


## Enables or disables both buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	add.disabled = not enabled
	skip.disabled = not enabled


## Called when the user selects a draftable [Card] on this screen.
func _on_card_selected(selected_card: CardData) -> void:
	for card in cards.get_children():
		if card.card != selected_card:
			card.deselect()
	
	picked_card = selected_card
