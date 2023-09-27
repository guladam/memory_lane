## Front view of a [Card]. Can be used universally where the 
## front of a [Card] can be seen. (in-game, card pile view etc.)
class_name CardFront
extends TextureRect


@onready var background: TextureRect = $Background
@onready var icon: TextureRect = $VBoxContainer/Icon
@onready var text1: Label = $VBoxContainer/TextAndStatusIcons/Text
@onready var status_icon1: TextureRect = $VBoxContainer/TextAndStatusIcons/StatusIcon
@onready var text2: Label = $VBoxContainer/TextAndStatusIcons2/Text
@onready var status_icon2: TextureRect = $VBoxContainer/TextAndStatusIcons2/StatusIcon
@onready var text_and_status_icons_2: HBoxContainer = $VBoxContainer/TextAndStatusIcons2


func setup(card: CardData, character: Character) -> void:
	icon.texture = card.card_icon
	icon.modulate = card.card_color
	text1.text = card.card_text
	text1.visible = card.card_text.length() > 0
	status_icon1.texture = card.card_status_icon
	status_icon1.visible = card.card_status_icon != null
	text2.text = card.card_text2
	text2.visible = card.card_text2.length() > 0
	status_icon2.texture = card.card_status_icon2
	status_icon2.visible = card.card_status_icon2 != null
	text_and_status_icons_2.visible = text2.visible and status_icon2.visible
	
	if character:
		background.texture = character.card_background
