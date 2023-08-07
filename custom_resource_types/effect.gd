## Effects resulting of matching [Card] pairs.
##
## These can be ranged / melee attacks, healing spells etc.
class_name Effect
extends Resource

## Types of targets for the different effects.
enum TargetType { BOARD, SELF, GROUND, AIR, ALL_ENEMIES }


@export var target_type: TargetType
@export var target: Node
@export var effect_name: String
@export var effect_code: GDScript

var _code: Node


## This is for injecting the Target dependency for an effect.
## After this, it should be implement its logic in a self contained manner
## in its [EffectCode].
func setup(_target: Node) -> void:
	target = _target
	_code = Node.new()
	_code.set_script(effect_code)
	_code.effect = self


## This is a public method for applying the logic this effect has.
## it relies on the [EffectCode] Node.
func apply_effect() -> void:
	if not _code:
		return
	
	await _code.apply_effect()
	_code.queue_free()
