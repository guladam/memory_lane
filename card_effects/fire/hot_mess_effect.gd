## [EffectCode] for applying temporary hot mess [StatusEffect].
extends EffectCode

var hot_mess_status := preload("res://status_effects/hot_mess.tres")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.status_effects.add_new_status(hot_mess_status)
	player.animation_player.play("cast_spell_finish")
	await player.animation_player.animation_finished
	player.animation_player.play("idle")
