extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

const EntityStatus = preload("./entity_status.gd")

var _entities_rule: AlephVault__WindRose.Rules.EntitiesRule

## Returns the entities rule for this manager.
var entities_rule: AlephVault__WindRose.Rules.EntitiesRule:
	get:
		return _entities_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesManager", "entities_rule"
		)

var _statuses: Dictionary

func get_status_for(entity_rule: AlephVault__WindRose.Rules.EntityRule):
	return _statuses.get(entity_rule)

## Construction takes the entities layer and
## keeps also the associated rule
func _init(entities_rule: AlephVault__WindRose.Rules.EntitiesRule) -> void:
	_entities_rule = entities_rule

## Initializes its state (and also the data of
## the underlying rule).
func initialize() -> void:
	entities_rule.initialize()
