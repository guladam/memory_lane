## This class represents a playable character in the game.
class_name Character
extends Resource


@export var name: String
@export var icon: Texture
@export var tooltip: String
@export var card_background: Texture
@export var color: Color
@export var select_sound: AudioStream
@export var starting_hp: int
@export var starting_deck: Deck
## This a collection of [StatusData] the [Player]
## has permanently with this character (e.g. a damage modifier)
@export var starting_traits: Array[StatusData]
## This is the collection of [CardData] the [Player] 
## can draft after winning levels.
@export var available_cards: Array[CardData]


## Returns true if the given Character is unlocked.
func is_unlocked() -> bool:
	match name:
		"Ice":
			return StatTracker.ice_unlocked
		"Earth":
			return StatTracker.earth_unlocked
		_:
			return true
