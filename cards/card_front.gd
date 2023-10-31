## Front view of a [Card]. Can be used universally where the 
## front of a [Card] can be seen. (in-game, card pile view etc.)
class_name CardFront
extends TextureRect


@onready var background: TextureRect = $Background
@onready var icon: TextureRect = %Icon
@onready var text: Label = %Text
@onready var target_icon_top_left: TextureRect = %TargetIconTopLeft
@onready var target_icon_top_right: TextureRect = %TargetIconTopRight
@onready var target_icon_bottom_right: TextureRect = %TargetIconBottomRight
@onready var target_icon_bottom_left: TextureRect = %TargetIconBottomLeft
@onready var target: TextureRect = %Target


func setup(card: CardData, character: Character) -> void:
	icon.texture = card.card_icon
	icon.modulate = card.card_color
	text.text = card.card_text
	text.visible = card.card_text.length() > 0
	target.texture = card.card_target_icon
	target_icon_bottom_left.texture = card.card_target_icon
	target_icon_bottom_right.texture = card.card_target_icon
	target_icon_top_left.texture = card.card_target_icon
	target_icon_top_right.texture = card.card_target_icon

	if character:
		background.texture = character.card_background
