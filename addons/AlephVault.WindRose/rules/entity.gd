extends Object
## An entity can be considered the counterpart of
## an entities manager. Entities are created with
## an entity rule in mind, also receiving the
## proper signals from the manager.

const _EntitiesManager = AlephVault__WindRose.Rules.EntitiesManager
const _EntityRule = AlephVault__WindRose.Rules.EntityRule
const _Response = AlephVault__WindRose.Utils.ExceptionUtils.Response
const _Exception = AlephVault__WindRose.Utils.ExceptionUtils.Exception
const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

var _manager: _EntitiesManager

## Returns the current manager this entity is
## attached / related to.
var manager: _EntitiesManager:
	get:
		return _manager
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "manager"
		)

var _entity_rule: _EntityRule

## The root entity rule for this entity.
var entity_rule: _EntityRule:
	get:
		return _entity_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "entity_rule"
		)

## The size of this entity.
var size: Vector2i:
	get:
		return _entity_rule.size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "size"
		)

func _on_attached(manager: _EntitiesManager, position: Vector2i):
	_manager = manager

func _on_detached():
	_manager = null

func _on_property_updated(property: String, old_value, new_value):
	if _manager != null:
		manager.property_updated(_entity_rule, property, old_value, new_value)

func _init(entity_rule: _EntityRule):
	if entity_rule == null or entity_rule.signals == null:
		assert(false, "The entity rule must not be non-null and have signals")
	else:
		_entity_rule = entity_rule
		_entity_rule.signals.on_attached.connect(_on_attached)
		_entity_rule.signals.on_detached.connect(_on_detached)
		_entity_rule.on_property_updated.connect(_on_property_updated)

## Attepts attachment to a manager.
func attach_to(
	manager: _EntitiesManager, position: Vector2i, force: bool = false
) -> _Response:
	if manager:
		if force:
			manager.detach(_entity_rule)
		else:
			return _Response.fail(_Exception.raise("already_attached", "Entity already attached to a manager"))
	return manager.attach(_entity_rule, position)

## Attempts detachment from a manager.
func detach() -> _Response:
	if _manager == null:
		return _Response.succeed(false)
	var response: _Response = _manager.detach(_entity_rule)
	if response.is_successful():
		return _Response.succeed(true)
	return response

## Returns the status from the current manager.
func get_status() -> _EntitiesManager.EntityStatus:
	if _manager == null or _entity_rule == null:
		return null
	return manager.get_status_for(_entity_rule)

## Tries to start a movement in a direction.
func movement_start(direction: _Direction, continued: bool = false) -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.movement_start(_entity_rule, direction, continued)

## Tries to cancel a current movement.
func movement_cancel() -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.movement_cancel(_entity_rule)

## Tries to finish a current movement.
func movement_finish() -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.movement_finish(_entity_rule)

## Tries to teleport the entity to a new position.
func teleport(to_position: Vector2i, silent: bool = false) -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.teleport(_entity_rule, to_position, silent)
