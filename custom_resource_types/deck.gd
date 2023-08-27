## A collection of [CardData] resources the player has.
##
## The player starts each game with a specific set
## of cards but they can add new ones between levels.
class_name Deck
extends Resource


## A deck is an array of [CardData] resources.
@export var cards: Array[CardData]
