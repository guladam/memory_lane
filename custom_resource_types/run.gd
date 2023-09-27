## This class represents a playthrough of the game.
class_name Run
extends Resource


@export var current_level := 1
@export var deck: Deck
@export var character: Character

var tier2_chance := 0.15
var tier3_chance := 0.02


func reset_tier2_chance() -> void:
	tier2_chance = 0.25
	

func reset_tier3_chance() -> void:
	tier3_chance = 0.02


func increase_tier2_chance() -> void:
	tier2_chance += 0.025


func increase_tier3_chance() -> void:
	tier3_chance += 0.02
