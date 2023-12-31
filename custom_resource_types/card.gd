## Data for the [Card] a player can draw from their deck.
##
## They main goal of the game is to match these cards together
## to fight enemies. Matching Cards together applies their [Effect].
class_name CardData
extends Resource

enum Tier { TIER_0, TIER_1, TIER_2, TIER_3 }

@export_category("Visuals")
@export var card_back: Texture = preload("res://cards/card_back.png")
@export var card_color: Color = Color.WHITE
@export var card_icon: Texture
@export var card_text: String
@export var card_target_icon: Texture
## Tooltip shown when tapped on the card.
@export var tooltips: Array[Tooltip]

@export_category("Audio")
@export var card_sound: AudioStream
@export var pitch: float = 1.0

@export_category("Other Data")
## A unique ID for the card, used for checking matches.
@export var id: String
## Tier of the card. Used when calculating drafting chances.
@export var tier: Tier
## The [Effect] this card creates when paired.
@export var effect: Effect
## If false, the [Player] can only draft this card once.
@export var can_have_multiple := true

## Returns true if the card's id matches the id of the [param other_card_data].
func is_matching(other_card_data: CardData) -> bool:
	return self.id == other_card_data.id


func _to_string() -> String:
	return "Card: %s" % id
