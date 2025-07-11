extends Object
## An entity can be considered the counterpart of
## an entities manager. Entities are created with
## an entity rule in mind, also receiving the
## proper signals from the manager.

const _EntitiesManager = AlephVault__WindRose.Core.EntitiesManager
const _EntityRule = AlephVault__WindRose.Core.EntityRule
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

var _cell: Vector2i

## The current cell this entity is into. It will
## be (-1, -1) if it's not attached to a map.
var cell: Vector2i:
	get:
		return _cell
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "cell"
		)

var _movement: _Direction

## The current movement direction. If it's NONE,
## then the entity is not moving.
var movement: _Direction:
	get:
		return _movement
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entity", "direction"
		)

func _on_attached(manager: _EntitiesManager, position: Vector2i):
	_manager = manager
	_cell = position

func _on_detached():
	_cell = Vector2i(-1, -1)
	_movement = _Direction.NONE
	_manager = null

func _on_property_updated(property: String, old_value, new_value):
	if _manager != null:
		manager.property_updated(_entity_rule, property, old_value, new_value)

func _on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	_movement = direction

func _on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	_movement = _Direction.NONE
	_cell = to_position

func _on_movement_cancelled(
	from_position: Vector2i, reverted_position: Vector2i,
	direction: _Direction
):
	_movement = _Direction.NONE

func _on_teleported_internal(
	from_position: Vector2i, to_position: Vector2i
):
	_cell = to_position

func _init(entity_rule: _EntityRule):
	if entity_rule == null or entity_rule.signals == null:
		assert(false, "The entity rule must not be non-null and have signals")
	else:
		_entity_rule = entity_rule
		_entity_rule.signals.on_attached.connect(_on_attached)
		_entity_rule.signals.on_detached.connect(_on_detached)
		_entity_rule.signals.on_movement_started.connect(_on_movement_started)
		_entity_rule.signals.on_movement_finished.connect(_on_movement_finished)
		_entity_rule.signals.on_movement_cancelled.connect(_on_movement_cancelled)
		_entity_rule.signals._on_teleported_internal.connect(_on_teleported_internal)
		_entity_rule.on_property_updated.connect(_on_property_updated)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if entity_rule != null and entity_rule.signals != null:
			_entity_rule.signals.on_attached.disconnect(_on_attached)
			_entity_rule.signals.on_detached.disconnect(_on_detached)
			_entity_rule.signals.on_movement_started.disconnect(_on_movement_started)
			_entity_rule.signals.on_movement_finished.disconnect(_on_movement_finished)
			_entity_rule.signals.on_movement_cancelled.disconnect(_on_movement_cancelled)
			_entity_rule.signals._on_teleported_internal.disconnect(_on_teleported_internal)
			_entity_rule.on_property_updated.disconnect(_on_property_updated)

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

## Tries to start a movement in a direction.
func movement_start(direction: _Direction, continued: bool = false) -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.movement_start(_entity_rule, direction)

## Tries to cancel a current movement.
func movement_cancel() -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.movement_cancel(_entity_rule)

## Tries to teleport the entity to a new position.
func teleport(to_position: Vector2i, silent: bool = false) -> _Response:
	if _manager == null:
		return _Response.fail(_Exception.raise("not_attached", "Entity not attached to a manager"))
	return _manager.teleport(_entity_rule, to_position, silent)
