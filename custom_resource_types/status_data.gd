## This is a data container [Resource] for [Status] effects.
class_name StatusData
extends Resource


## Unique id of the status effect.
@export var status_id: String
## The duration of the status effect in turns.
## -1 means its a permanent status effect. 
@export var duration := -1
@export var icon: Status.Icons
@export var code: GDScript
