## This is a data container [Resource] for [Status] effects.
class_name StatusData
extends Resource


## Unique id of the status effect.
@export var status_id: String
## The duration of the status effect in turns.
## -1 means its a permanent status effect. 
@export var duration := -1
## True if the duration of the status should decrease by one 
## at the start of every turn. If not, the effect will be
## stackable but never expires (like Frost).
@export var temporary_duration := true
@export var icon: Status.Icons
@export var tooltip: Tooltip
@export var code: GDScript
