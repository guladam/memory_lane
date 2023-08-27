class_name Status
extends Node

signal status_expired
signal status_applied

enum Icons {FIRE, ICE}
const ICONS := {
	Icons.FIRE: preload("res://temp/card_012.png"),
	Icons.ICE: preload("res://temp/card_013.png")
}

var data: StatusData
var duration := -1
var icon_texture: Texture


func _ready() -> void:
	status_applied.connect(_on_status_applied)


func setup(_data: StatusData) -> void:
	data = _data
	duration = _data.duration
	icon_texture = ICONS[_data.icon]


func apply_status(target: Node) -> void:
	print("apply %s status to %s" % [data.status_id, target])
	


func _on_status_applied() -> void:
	if duration > 0:
		duration -= 1

	if duration == 0:
		print("status %s expired" % data.status_id)
		status_expired.emit(self)
		queue_free()
