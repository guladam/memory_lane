extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Text


func setup(_icon: Texture, _text: String) -> void:
	icon.texture = _icon
	label.text = _text.c_unescape()
	
	if not _icon:
		icon.hide()
