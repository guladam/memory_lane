extends Sprite2D


@export var sound: AudioStream


func _ready() -> void:
	SfxPlayer.play(sound, true)
