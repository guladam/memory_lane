## Represent a status effects which can affect both [Enemy] and [Player] units.
class_name Status
extends Node

## Emitted when the status effect expires. 
## Note: permanent status effects should never emit this signal.
signal status_expired
## Emitted when the status effect gets applied to the target unit.
signal status_applied

## Available icons for ALL status effects.
enum Icons {FIRE, ICE}
## Preloaded textures for the icons above.
const ICONS := {
	Icons.FIRE: preload("res://temp/card_012.png"),
	Icons.ICE: preload("res://temp/card_013.png")
}

## [StatusData] resource for this status effect.
var data: StatusData
## Duration of the effect, in turns. -1 means it's a permanent status effect.
var duration := -1
## Icon [Texture] of the status effect.
var icon_texture: Texture


func _ready() -> void:
	status_applied.connect(_on_status_applied)


## This method is used for dependency injection.
## [param _data] is the [StatusData] resource for this status effect.
func setup(_data: StatusData) -> void:
	data = _data
	duration = _data.duration
	icon_texture = ICONS[_data.icon]


## This a virtual method for applying the status effect to its target.
## This should always be overwritten by any inherited status effect.
## Also, the implementing methods should always emit the [signal Status.status_applied] signal.
## [param target] is the unit receiving this status effect.
func apply_status(target: Node) -> void:
	print("apply %s status to %s" % [data.status_id, target])


## Called when the status effect is applied to the target.
func _on_status_applied() -> void:
	if duration > 0:
		duration -= 1

	if duration == 0:
		print("status %s expired" % data.status_id)
		status_expired.emit(self)
		queue_free()
