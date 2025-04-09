extends Node2D
## Entities are the life inside maps. These
## objects can have movement and respond to
## stimuli from the map and other entities.

@export var _rule_spec: AlephVault__WindRose.Rules.EntityRuleSpec

var _rule: AlephVault__WindRose.Rules.EntityRule

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

var _size: Vector2i

## Returns the size for this entity.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "size"
		)

# TODO continue.
