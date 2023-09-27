## A card which can be selected to draft into a [Deck].
extends Control

## Emitted when the draftable card is selected.
signal selected(card: CardData, card_gui: Control)

@onready var card_front: TextureRect = $CardFront
@onready var selection_panel: Panel = $SelectionPanel
var card: CardData
var t: Tween


## Setting up the visuals based on the data.
## [param _card] is the [CardData] resource.
## [param character] is the current [Character].
func setup(_card: CardData, character: Character) -> void:
	card = _card
	card_front.setup(_card, character)
	var panel: StyleBoxFlat = selection_panel.get("theme_override_styles/panel")
	panel.border_color = character.color
	panel.border_color.a = 255 * 0.6
	selection_panel.hide()
	

## Deselects the draftable card.
func deselect() -> void:
	if t:
		t.kill()
		
	selection_panel.hide()


## Selects the draftable card.
func select() -> void:
	selection_panel.show()
	_animate()


## Animates the border of the selection panel infinitely.
func _animate() -> void:
	if t and t.is_running():
		return
	
	var panel: StyleBoxFlat = selection_panel.get("theme_override_styles/panel")
	t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	t = t.set_loops()
	t.tween_property(panel, "border_color:a", 1.0, 0.4)
	t.tween_interval(0.3)
	t.tween_property(panel, "border_color:a", 0.6, 0.4)


## Selects the draftable card when its clicked.
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("tap"):
		select()
		selected.emit(card, self)
