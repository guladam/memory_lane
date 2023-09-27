## This screen is shown when a [Level] is won and the [Player]
## can draft new [Card]s to their [Deck].
extends ColorRect

## Emitted when the user has selected a card to draft, or when they
## skipped the reward.
signal card_drafted(new_card: CardData)

@onready var add: Button = %Add
@onready var skip: Button = %Skip
@onready var cards: HBoxContainer = %Cards
@onready var character_icon: TextureRect = %CharacterIcon
@onready var draftable_card := preload("res://ui/draftable_card.tscn")

var run: Run
var picked_card: CardData


func _ready() -> void:
	add.pressed.connect(func(): card_drafted.emit(picked_card))
	skip.pressed.connect(func(): card_drafted.emit(null))


## This method sets the screen up before showing it.
## [param run] is the data for the current [Run].
func setup(_run: Run) -> void:
	run = _run
	var rewards: Array[CardData] = _get_rewards()
	
	for card in rewards:
		var new_draftable_card := draftable_card.instantiate()
		cards.add_child(new_draftable_card)
		new_draftable_card.setup(card, run.character)
		new_draftable_card.selected.connect(_on_card_selected)
	
	character_icon.texture = run.character.icon
	cards.get_child(0).select()
	picked_card = cards.get_child(0).card
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Events.card_tooltip_requested.emit(picked_card, cards.get_child(0))


## Enables or disables both buttons.
## [param enabled] is true if you want the buttons to be enabled.
func set_buttons(enabled: bool) -> void:
	add.disabled = not enabled
	skip.disabled = not enabled


## Returns draftable card rewards based on the current chances.
func _get_rewards() -> Array[CardData]:
	var rewards: Array[CardData] = []
	var all_cards := run.character.available_cards.duplicate(true)
	var has_tier3 := false
	var has_tier2 := false
	
	while rewards.size() < 3:
		var roll := randf()
		
		if not has_tier3 and roll <= run.tier3_chance:
			print("rolled tier3")
			rewards.append(all_cards.filter(_is_tier3).pick_random())
			run.reset_tier3_chance()
		elif not has_tier2 and roll <= run.tier2_chance:
			print("rolled tier2")
			rewards.append(all_cards.filter(_is_tier2).pick_random())
			run.reset_tier2_chance()
		else:
			print("rolled low...")
			var card: CardData
			var not_new_card := true
			while not_new_card:
				card = all_cards.filter(_is_tier1).pick_random()
				not_new_card = rewards.has(card)
			rewards.append(card)
		
		has_tier3 = rewards.any(_is_tier3)
		has_tier2 = rewards.any(_is_tier2)
	
	if not has_tier3:
		run.increase_tier3_chance()
	if not has_tier2:
		run.increase_tier2_chance()
	
	print("chances for tier2: %s | tier3: %s" % [run.tier2_chance, run.tier3_chance])

	return rewards


func _is_tier3(c) -> bool:
	return c.tier == CardData.Tier.TIER_3


func _is_tier2(c) -> bool:
	return c.tier == CardData.Tier.TIER_2


func _is_tier1(c) -> bool:
	return c.tier == CardData.Tier.TIER_1


## Called when the user selects a draftable [Card] on this screen.
func _on_card_selected(selected_card: CardData, card_gui: Control) -> void:
	for card in cards.get_children():
		if card.card != selected_card:
			card.deselect()
	
	picked_card = selected_card
	Events.card_tooltip_requested.emit(selected_card, card_gui)
