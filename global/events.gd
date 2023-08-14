## Event bus for global events to avoid distant passing of signals.
## This is a Singleton Class added as an autoload.
## Mainly used for [Effect]s of [Card]s.
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
## Emitted when the deck is reshuffled because there
## were no more cards left in the draw pile.
signal draw_pile_reshuffled(cards_still_needed: int)
## Emitted when a card reshuffle animation is started.
signal card_reshuffle_anim_started
## Emitted when a card reshuffle animation has finished.
signal card_reshuffle_anim_finished

## Emitted when a [Card] produces an [Effect].
signal effect_created(effect: Effect)
