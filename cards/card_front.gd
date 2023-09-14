## Front view of a [Card]. Can be used universally where the 
## front of a [Card] can be seen. (in-game, card pile view etc.)
class_name CardFront
extends TextureRect


@onready var background: TextureRect = $Background
@onready var icon: TextureRect = $Icon
@onready var text: Label = $TextAndStatusIcons/Text
@onready var status_icon: TextureRect = $TextAndStatusIcons/StatusIcon


func setup(card: CardData, character: Character) -> void:
	icon.texture = card.card_icon
	icon.modulate = card.card_color
	text.text = card.card_text
	text.visible = card.card_text.length() > 0
	status_icon.texture = card.card_status_icon
	status_icon.visible = card.card_status_icon != null
	
	if character:
		background.texture = character.card_background
