extends AlephVault__WindRose.Maps.Layers.Layer
## This is an entities layer. It holds a reference to a
## resource that will spawn an underlying rule.
##
## Override this class' _create_rule to return a custom
## instance of AlephVault__WindRose.Core.EntitiesRule.
## This will be assigned internally to the `rule` field,
## perhaps initialized from custom properties you define.

const _Map = AlephVault__WindRose.Maps.Map
const _EntitiesRule = AlephVault__WindRose.Core.EntitiesRule

## An entities manager aware of this layer.
class Manager extends AlephVault__WindRose.Core.EntitiesManager:
	"""
	An entities manager related to an entities layer considers
	specific entity object subtypes: MapEntity.Entity. This one
	properly links the logic to their underlying MapEntity that
	was it created for.
	
	Also, it will manage the objects themselves (their movement).
	"""

	var _layer
	
	## The layer this manager is bound to.
	var layer:
		get:
			return _layer
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"EntitiesLayer.Manager", "layer"
			)
	
	func _get_point(cell: Vector2i):
		return _layer.map.layout.get_point(cell)
	
	func _get_frame_signal():
		return _layer.get_tree().process_frame
	
	func _get_object_for_entity(entity):
		return entity.map_entity

	func _get_entity_for_object(obj):
		return obj.entity
	
	func _get_speed_for_object(obj) -> float:
		return obj.speed

	func _init(layer, entities_rule: _EntitiesRule, bypass):
		super._init(entities_rule, bypass)
		_layer = layer

var _rule: _EntitiesRule

func _create_rule() -> _EntitiesRule:
	"""
	Creates an entities rule.
	"""
	
	return null

## The instantiated rule, out of the configured
## rule spec.
var rule: _EntitiesRule:
	get:
		if is_instance_valid(_rule):
			return _rule

		_rule = _create_rule()
		assert(
			is_instance_valid(_rule),
			"Implement entities_layer's _create_rule() to return a non-null " + 
			"AlephVault__Windrose.Core.EntitiesRule instance"
		)
		return _rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesLayer", "rule"
		)

# The manager for this layer.
var _manager: Manager

## The manager for this layer.
var manager: Manager:
	get:
		assert(
			_manager != null,
			"EntitiesLayer's manager is not initialized yet"
		)
		return _manager
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesLayer", "manager"
		)

## Whether to ensure that, locally, the rules
## are bypassed (useful for stuff like online
## games where the truth is server-side).
@export var _bypass: bool = false

## Whether to ensure that, locally, the rules
## are bypassed (useful for stuff like online
## games where the truth is server-side).
var bypass: bool:
	get:
		return _bypass
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesLayer", "bypass"
		)

var _initialized: bool = false

## Whether it's already initialized or not.
var initialized: bool:
	get:
		return _initialized
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesLayer", "initialized"
		)

## Initializes the manager.
func initialize():
	if not _map:
		return
	
	if not _initialized:
		_manager = Manager.new(self, rule, bypass)
		_manager.initialize()
		_initialized = true

## We leave the _z_index in 30 here, explicitly.
## We leave space for few layers under the feet
## of the characters.
func _z_index() -> int:
	return 30
