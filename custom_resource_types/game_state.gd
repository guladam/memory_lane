## Resource representing the current GameState.
class_name GameState
extends Resource

## An enum holding all available [GameState]s.
enum State {PLAYING, PAUSED}

## Emitted when the game state is changed.
signal game_state_changed(new_state: State)

## The current state of the game.
@export var state: State

## Change the current state to [param new_state].
func change_to(new_state: State) -> void:
	if new_state != state:
		game_state_changed.emit(new_state)
	
	state = new_state


## Returns [code]true[/code] if the game is currently paused.
func is_paused() -> bool:
	return state == State.PAUSED


## Resets the game state to the default state.
func reset() -> void:
	change_to(State.PLAYING)
