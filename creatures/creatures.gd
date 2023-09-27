extends Node2D

@onready var border_bottom: Sprite2D = $BorderBottom


func _ready() -> void:
	if DisplayServer.screen_get_size().y > 1920:
		var offset := (DisplayServer.screen_get_size().y - 1920) / 4.0
		position.y = offset
		border_bottom.position.y += offset / 2.0
