extends Button


@export var icon_on: Texture
@export var icon_off: Texture

@onready var icon_texture: TextureRect = $Icon


func _ready() -> void:
	icon_texture.texture = icon_on
	toggled.connect(set_icon_texture)


func set_icon_texture(enabled: bool) -> void:
	icon_texture.texture = icon_on if not enabled else icon_off
