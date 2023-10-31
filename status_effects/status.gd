## Represent a status effects which can affect both [Enemy] and [Player] units.
class_name Status
extends Node

## Emitted when the status effect expires. 
## Note: permanent status effects should never emit this signal.
signal status_expired
## Emitted when the status effect gets applied to the target unit.
signal status_applied

## Available icons for ALL status effects.
enum Icons {FIRE, ICE, REVEAL, HOT_MESS, FIRE_STARTER, ICE_STARTER, FUEL, GAS_STATION, FREEZING_TIME}
## Preloaded textures for the icons above.
const ICONS := {
	Icons.FIRE: preload("res://status_effects/fire_icon.png"),
	Icons.ICE: preload("res://status_effects/ice_icon.png"),
	Icons.REVEAL: preload("res://status_effects/reveal_icon.png"),
	Icons.HOT_MESS: preload("res://status_effects/hot_mess_icon.png"),
	Icons.FIRE_STARTER: preload("res://status_effects/fire_starter_icon.png"),
	Icons.ICE_STARTER: preload("res://status_effects/ice_starter_icon.png"),
	Icons.FUEL: preload("res://status_effects/fuel_icon.png"),
	Icons.GAS_STATION: preload("res://status_effects/gas_station_icon.png"),
	Icons.FREEZING_TIME: preload("res://cards/freeze_skip_icon.png")
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
	print("applied %s status to %s" % [data.status_id, target])


## Called when there is a special need of logic to get rid of 
## status side effect. Eg. remove all movement modifiers for frost effects.
func remove() -> void:
	queue_free()


## Returns [code]true[/code] if this status is the same as
## the [param other] one.
func equals(other: StatusData) -> bool:
	return data.status_id == other.status_id


## Called when the status effect is applied to the target.
func _on_status_applied() -> void:
	if duration > 0 and data.temporary_duration:
		duration -= 1

	if duration == 0:
		print("status %s expired" % data.status_id)
		status_expired.emit(self)
		queue_free()
