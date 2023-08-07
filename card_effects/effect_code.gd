## Class for encapsulating the code logic for an [Effect].
## Needs to have access for the [Effect] it belongs to.
class_name EffectCode
extends Node


## the [Effect] this code belongs to.
var effect: Effect


## This is a virtual function used for the effect logic.
## It needs to implemented by the specific effects.
func apply_effect() -> void:
	pass
