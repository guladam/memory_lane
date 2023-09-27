## Effects resulting of matching [Card] pairs.
##
## These can be ranged / melee attacks, healing spells etc.
class_name Effect
extends Resource

## Types of targets for the different effects.
enum TargetType { BOARD, SELF, GROUND, AIR, ALL_GROUND, ALL_AIR, ALL_ENEMIES, EVERYONE }

@export var target_type: TargetType
@export var anim_name: String
@export var effect_name: String
@export var effect_code: GDScript


var targets: Array[Node]
var _code: Node


## This is for injecting the Target dependency for an effect.
## After this, it should be implement its logic in a self contained manner
## in its [EffectCode].
func setup(_targets: Array[Node]) -> void:
	targets = _targets
	_code = Node.new()
	_code.set_script(effect_code)
	_code.effect = self


## This is a public method for applying the logic this effect has.
## it relies on the [EffectCode] Node.
func apply_effect() -> void:
	if not _code:
		return
	
	await _code.apply_effect()
	Events.player_turn_ended.emit()
	_code.queue_free()
