extends CenterContainer

@onready var texture: TextureRect = $Texture

func setup(card_data: CardData) -> void:
	texture.texture = card_data.card_front
