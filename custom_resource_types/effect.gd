## Effects resulting of matching [Card] pairs.
##
## These can be ranged / melee attacks, healing spells etc.
class_name Effect
extends Resource

enum TargetType { SELF, GROUND, AIR, ALL_ENEMIES }


@export var target_type: TargetType
@export var name: String
