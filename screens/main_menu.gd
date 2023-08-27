extends VBoxContainer


signal credits_requested
signal new_game_requested

@onready var play: Button = %Play
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	play.pressed.connect(func(): new_game_requested.emit())
	credits.pressed.connect(func(): credits_requested.emit())
	quit.pressed.connect(get_tree().quit)


func set_buttons(enabled: bool) -> void:
	play.disabled = not enabled
	credits.disabled = not enabled
	quit.disabled = not enabled
