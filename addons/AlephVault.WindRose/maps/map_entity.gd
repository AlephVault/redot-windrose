extends Node2D

const _EntityRule = AlephVault__WindRose.Core.EntityRule

## An entities manager aware of this layer.
class Entity extends AlephVault__WindRose.Core.Entity:
	
	var _map_entity
	
	## The map entity this manager is bound to.
	var map_entity:
		get:
			return _map_entity
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapEntity.Entity", "map_entity"
			)

	func _init(map_entity, entity_rule: _EntityRule):
		super._init(entity_rule)
		_map_entity = map_entity

## The associated entity rule. This one must be an
## EXTERNAL resource, defined in a resource file
## (it cannot be an embedded resource), which is
## necessarily of a derived class.
##
## In the end, the actual entity rule will be
## instantiated out of it. 
@export var _rule_spec: AlephVault__WindRose.Resources.EntityRuleSpec

var _rule: _EntityRule

## The instantiated rule, out of the configured
## rule spec.
var rule: _EntityRule:
	get:
		if is_instance_valid(_rule):
			return _rule

		assert(
			_rule_spec != null,
			"The rule_spec is not set"
		)
		_rule = _rule_spec.create_rule(self)
		assert(
			is_instance_valid(_rule),
			"The rule is null"
		)
		return _rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "rule"
		)

var _entity: Entity

## The underlying logical entity for
## this map entity.
var entity: Entity:
	get:
		return _entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "entity"
		)

var _initialized: bool

func _set_signals():
	# TODO set the signals as per https://github.com/AlephVault/unity-windrose/blob/main/Runtime/Authoring/Behaviours/Entities/Objects/MapObject.cs#L58.
	pass

func _init():
	_entity = Entity.new(self, rule)
	_set_signals()

## Initializes this object.
func initialize():
	if Engine.is_editor_hint():
		return
	
	if _initialized:
		return

	entity.initialize()
	
	var _parent = get_parent()
	var _parent2 = null
	if _parent != null:
		_parent2 = _parent.get_parent()
	if _parent2 is AlephVault__WindRose.Maps.Map and \
	   _parent2.layout != null and \
	   _parent is AlephVault__WindRose.Maps.Layers.EntitiesLayer:
		if not _parent.initialized:
			return
		var cell = _parent2.layout.local_to_map(position)
		var result = _parent.manager.attach(
			entity.entity_rule, cell
		)
		if result.is_successful():
			_initialized = true

func _ready():
	initialize()
