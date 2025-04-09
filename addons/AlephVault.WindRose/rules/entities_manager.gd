extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

var _entities_rule: AlephVault__WindRose.Rules.EntitiesRule

## Returns the entities rule for this manager.
var entities_rule: AlephVault__WindRose.Rules.EntitiesRule:
	get:
		return _entities_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesManager", "entities_rule"
		)

var _entities_layer

## Returns the associated entity layer.
var entities_layer:
	get:
		return _entities_layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesManager", "entities_layer"
		)

## Construction takes the entities layer and
## keeps also the associated rule
func _init(entities_layer: AlephVault__WindRose.Entities.Layer) -> void:
	_entities_layer = entities_layer
	_entities_rule = entities_layer.rule

## Initializes its state (also means: initializes
## the underlying rule). By this point, this means
## the layout is already initialized as well (e.g.
## the entities layer will be ready).
func initialize() -> void:
	entities_rule.initialize()
