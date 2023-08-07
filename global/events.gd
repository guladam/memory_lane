## Event bus for global events to avoid distant passing of signals.
## This is a Singleton Class added as an autoload.
## Mainly used for [Effect]s of [Card]s.
extends Node

## Emitted when a [Card] produces an [Effect].
signal effect_created(effect: Effect)
