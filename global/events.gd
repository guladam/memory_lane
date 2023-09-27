## Event bus for global events to avoid distant passing of signals.
## This is a Singleton Class added as an autoload.
extends Node


## Emitted when a [Card] draw animation is started.
signal card_draw_started(card: Card)
## Emitted when a [Card] draw animation has finished.
signal card_drawn(card: Card)
## Emitted when a [Card] discard animation is started.
signal card_discard_started(card: Card)
## Emitted when a [Card] discard animation has finished.
signal card_discarded(card: Card)
## Emitted when a [Card] match animation is started.
signal card_match_started(card: Card)
## Emitted when a [Card] match animation has finished.
signal card_matched(card: Card)
## Emitted when a [Card] flip animation is started.
signal card_flip_started(card: Card)
## Emitted when a [Card] flip animation has finished.
signal card_flipped(card: Card)
## Emitted when a [Card] unflip animation is started.
signal card_unflip_started(card: Card)
## Emitted when a [Card] unflip animation has finished.
signal card_unflipped(card: Card)

## Emitted when the player tried to match 2 different [Card]s,
## before the animation is finished.
signal cards_mismatched
## Emitted when the [Board] is emptied and needs new [Card]s.
signal board_emptied
## Emitted when the [Board] needs to reveal an [param amount] of [Card]s.
signal board_reveal_requested(amount: int)
## Emitted when the deck is reshuffled because there
## were no more cards left in the draw pile.
signal draw_pile_reshuffled(cards_still_needed: int)
## Emitted when a card reshuffle animation is started.
signal card_reshuffle_anim_started
## Emitted when a card reshuffle animation has finished.
signal card_reshuffle_anim_finished

## Emitted when a [Card] produces an [Effect].
signal effect_created(effect: Effect)
## Emitted when an [Effect] wants to spawn a projectile from the [Player].
signal projectile_spawn_requested(target: Vector2, projectile: PackedScene, start: Vector2)
## Emitted when an outside source wants to add a damage modifier to the [Player]
signal player_damage_modifier_requested(dmg_modifier: int, duration: int)
## Emitted when someone wants to add a [Status] to a random [Enemy].
signal add_status_to_random_enemy_requested(status: StatusData)

## Emitted when the [Player]'s turn starts.
signal player_turn_started
## Emitted when the [Player]'s turn ends.
signal player_turn_ended
## Emitted when the [Enemy]'s turn starts.
signal enemy_turn_started
## Emitted when the [Enemy]'s turn ends.
signal enemy_turn_ended
## Emitted when an [Enemy] dies.
signal enemy_died(enemy: Enemy)

## Emitted when the [Player] wins the level.
signal level_won(level: LevelData)
## Emitted when the [Player] loses the level.
signal game_over
## Emitted when a whole run is won by the [Player].
signal run_won


## Emitted when a CardPilePanel is requested to show.
signal card_pile_panel_requested(title: String, cards: Array[CardData])
## Emitted when a tooltip for a [Card] is requested.
signal card_tooltip_requested(card: CardData, gui_element: Control)
## Emitted when [Status] tooltips for a unit are requested.
signal status_tooltip_requested(statuses: Array[StatusData], unit: Node2D)
