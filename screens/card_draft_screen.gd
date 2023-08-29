extends ColorRect

signal card_drafted(new_card: CardData)

@onready var add: Button = %Add
@onready var skip: Button = %Skip
@onready var cards: HBoxContainer = %Cards
@onready var draftable_card := preload("res://ui/draftable_card.tscn")

var picked_card: CardData


func _ready() -> void:
	add.pressed.connect(func(): card_drafted.emit(picked_card))
	skip.pressed.connect(func(): card_drafted.emit(null))


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


func set_buttons(enabled: bool) -> void:
	add.disabled = not enabled
	skip.disabled = not enabled


func _on_card_selected(selected_card: CardData) -> void:
	for card in cards.get_children():
		if card.card != selected_card:
			card.deselect()
	
	picked_card = selected_card
