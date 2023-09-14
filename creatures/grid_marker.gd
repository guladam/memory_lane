## Marks grid positions on the map.
## If an [Enemy] stands on it, changes its color
## according to the intent of that unit.
class_name GridMarker
extends Sprite2D


@export var default_color: Color
@export var attack_color: Color
@export var move_color: Color

@onready var intent_colors := {
	Enemy.Intents.NONE: self.default_color,
	Enemy.Intents.ATTACK: self.attack_color,
	Enemy.Intents.MOVE: self.move_color
}


## Changes the color of the grid based on the [param intent].
func change_color(intent: Enemy.Intents) -> void:
	self.modulate = intent_colors[intent]
