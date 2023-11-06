## This screen is shown when a [Level] is won and the [Player]
## can draft new [Card]s to their [Deck].
extends TextureRect

## Emitted when the user has selected a card to draft, or when they
## skipped the reward.
signal card_drafted(new_card: CardData)

@onready var add: Button = %Add
@onready var skip: Button = %Skip
@onready var cards: HBoxContainer = %Cards
@onready var character_icon: TextureRect = %CharacterIcon
@onready var draftable_card := preload("res://ui/draftable_card.tscn")
@onready var reroll: Button = %Reroll
@onready var reroll_label: Label = %RerollLabel
@onready var reroll_disabled_panel: Panel = %RerollDisabledPanel
@onready var deck_view_button: Button = $DeckViewButton
@onready var card_pile_panel: CenterContainer = $CardPilePanel
@onready var tooltip_manager: Control = $TooltipManager

var run: Run
var picked_card: CardData
var picked_card_gui: Control
var rerolls: int


func _ready() -> void:
	add.pressed.connect(func(): card_drafted.emit(picked_card))
	skip.pressed.connect(func(): card_drafted.emit(null))
	reroll.pressed.connect(_on_reroll_pressed)
	deck_view_button.pressed.connect(_on_deck_view_button_pressed)
	rerolls = StatTracker.rerolls
	

## This method sets the screen up before showing it.
## [param run] is the data for the current [Run].
func setup(_run: Run) -> void:
	run = _run
	character_icon.texture = run.character.icon
	_setup_card_rewards()
	_setup_rerolls()

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


## This method generates a new set of reward cards.
## Called when initializing this screen or when the
## Player wants to reroll their rewards.
func _setup_card_rewards() -> void:
	var rewards: Array[CardData] = _get_rewards()
	
	for card in rewards:
		var new_draftable_card := draftable_card.instantiate()
		cards.add_child(new_draftable_card)
		new_draftable_card.setup(card, run.character)
		new_draftable_card.selected.connect(_on_card_selected)
	
	cards.get_child(0).select()
	picked_card = cards.get_child(0).card
	picked_card_gui = cards.get_child(0)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Events.card_tooltip_requested.emit(picked_card, cards.get_child(0))


## Sets the reroll button and related visuals.
func _setup_rerolls() -> void:
	reroll.disabled = rerolls <= 0
	reroll_disabled_panel.visible = rerolls <= 0
	reroll_label.text = "Reroll (%s)" % rerolls


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
	picked_card_gui = card_gui
	Events.card_tooltip_requested.emit(selected_card, card_gui)


## Called when the user rerolls their reward.
func _on_reroll_pressed() -> void:
	Events.card_rewards_rerolled.emit()
	rerolls -= 1
	_setup_rerolls()
	
	for c in cards.get_children():
		c.queue_free()
	
	_setup_card_rewards()


## Called when the user presses the view deck button.
func _on_deck_view_button_pressed() -> void:
	tooltip_manager.clear_tooltip()
	tooltip_manager.delete_current_tooltip_reference()
	card_pile_panel.show_panel("Deck", run.deck.cards, run.character)


## Called when the View Deck panel is closed.
func _on_card_pile_panel_closed() -> void:
	tooltip_manager.clear_tooltip()
	tooltip_manager.delete_current_tooltip_reference()
	Events.card_tooltip_requested.emit(picked_card, picked_card_gui)
