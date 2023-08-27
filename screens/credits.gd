extends VBoxContainer

signal main_menu_requested

@onready var back: Button = %Back

func _ready() -> void:
	back.pressed.connect(func(): main_menu_requested.emit())


func set_buttons(enabled: bool) -> void:
	back.disabled = not enabled
