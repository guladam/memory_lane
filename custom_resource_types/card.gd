## Data for the [Card] a player can draw from their deck.
##
## They main goal of the game is to match these cards together
## to fight enemies. Matching Cards together applies their [Effect].
class_name CardData
extends Resource


@export var card_back: Texture = preload("res://temp/card_000.png")
@export var card_front: Texture
## A unique ID for the card, used for checking matches.
@export var id: String
## The [Effect] matching these cards together has.
@export var effect: Effect


## Returns true if the card's id matches the id of the [param other_card_data].
func is_matching(other_card_data: CardData) -> bool:
	return self.id == other_card_data.id


func _to_string() -> String:
	return "Card: %s" % id
