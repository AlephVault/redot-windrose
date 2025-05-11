extends Node2D
## Entities are the life inside maps. These
## objects can have movement and respond to
## stimuli from the map and other entities.

@export var _rule_spec: AlephVault__WindRose.Core.EntityRuleSpec

var _rule: AlephVault__WindRose.Core.EntityRule

## Returns the associated rule, perhaps
## creating it first.
var rule:
	get:
		if _rule == null:
			assert(_rule_spec != null, "The rule must be set for Entity objects")
			_rule = _rule_spec.create_rule(self)
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "rule"
		)

@export var _size: Vector2i

## Returns the size for this entity.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "size"
		)

var _initialized: bool = false;
var _movementCount: int = 0;
var _destroyed: bool = false;

func _init() -> void:
	# on_attached.connect()
	pass
