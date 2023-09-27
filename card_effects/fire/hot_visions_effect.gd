## [EffectCode] for getting reveal status for 3 turns while applying 2 self-burn.
extends EffectCode

var ignite_status := preload("res://status_effects/ignited_2_data.tres")
var reveal_status := preload("res://status_effects/reveal_2_3_turns.tres")

## Overrides the virtual method of the [EffectCode] parent class.
func apply_effect() -> void:
	var player = effect.targets[0] as Player
	if not player:
		return
	
	player.status_effects.add_new_status(reveal_status)
	player.status_effects.add_new_status(ignite_status)
	player.animation_player.play("cast_spell_finish")
	await player.animation_player.animation_finished
	player.animation_player.play("idle")
