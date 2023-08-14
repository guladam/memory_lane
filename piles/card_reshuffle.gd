extends Path2D


## Called when the reshuffle starts animating
func reshuffle_started() -> void:
	Events.card_reshuffle_anim_started.emit()


## Called when the reshuffle animation has finished
func reshuffle_finished() -> void:
	Events.card_reshuffle_anim_finished.emit()
