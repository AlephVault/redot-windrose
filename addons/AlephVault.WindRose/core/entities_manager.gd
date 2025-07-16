extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _Entity = AlephVault__WindRose.Core.Entity
const _EntityRule = AlephVault__WindRose.Core.EntityRule
const _EntitiesRule = AlephVault__WindRose.Core.EntitiesRule
const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction
const EntityStatus = preload("./entity_status.gd")

var _entities_rule: _EntitiesRule

## Returns the entities rule for this manager.
var entities_rule: _EntitiesRule:
	get:
		return _entities_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesManager", "entities_rule"
		)

var _statuses: Dictionary
var _movement_manager: AlephVault__WindRose.WREngine.MovementManager
var _bypass

## Whether to bypass any veto or not. Useful
## for online games, where the truth is in the
## server and not here.
var bypass: bool:
	get:
		if _bypass is Callable:
			return _bypass.call()
		else:
			return bool(_bypass)
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesManager", "entities_rule"
		)

## Gets the current status for an entity rule.
func get_status_for(entity_rule: _EntityRule):
	return _statuses.get(entity_rule)

func _require_not_attached(entity_rule: _EntityRule) -> _Exception:
	if _statuses.has(entity_rule):
		return _Exception.raise("already_attached", "The entity is already attached")
	return null

func _require_attached(entity_rule: _EntityRule) -> _Exception:
	if not _statuses.has(entity_rule):
		return _Exception.raise("not_attached", "The entity is not attached")
	return null

## Construction takes the entities layer and
## keeps also the associated rule
func _init(entities_rule: _EntitiesRule, bypass) -> void:
	_entities_rule = entities_rule
	_bypass = bypass
	_movement_manager = AlephVault__WindRose.WREngine.MovementManager.new(
		# Function to get the frame signal.
		func(): return _get_frame_signal(),
		# Function to get the raw position.
		func(position): return _get_point(position),
		# Function to get the speed of an object.s
		_get_speed_for_object,
		# Applies the same logic to test whether the
		# object can start the (new) movement or not.
		func(obj, direction):
			print("GLORG(5)! Statuses: ", _statuses, "Obj: ", obj, "Entity: ", _get_entity_for_object(obj), "Direction: ", direction)
			return self._can_allocate(
				_get_entity_for_object(obj).entity_rule,
				_statuses[_get_entity_for_object(obj).entity_rule].position,
				direction
			),
		self._on_movement_rejected_callback,
		self._on_movement_started_callback,
		self._on_movement_finished_callback,
		self._on_movement_cancelled_callback,
		.25
	)

## Initializes its state (and also the data of
## the underlying rule).
func initialize() -> void:
	entities_rule.initialize()

## Attaches an entity to the current rule.
func attach(entity: _Entity, to_position: Vector2i) -> _Response:
	var entity_rule: _EntityRule = entity.entity_rule
	if entity_rule == null:
		return _Response.fail(_Exception.raise("null_value", "Null value not allowed"))
	var e: _Exception
	# Check is not attached.
	e = _require_not_attached(entity_rule)
	if e:
		return _Response.fail(e)
	# Check allowance.
	if not _can_attach(entity_rule, to_position):
		return _Response.fail(_Exception.raise("not_allowed", "Entity not allowed"))
	# Check boundaries.
	var ss: Vector2i = entities_rule.size
	var s: Vector2i = entity_rule.size
	var f: Vector2i = s + to_position
	if to_position.x < 0 or to_position.y < 0 or f.x > ss.x or f.y > ss.y:
		return _Response.fail(_Exception.raise("outbound", "Position out of bounds"))
	# Register status.
	_statuses[entity_rule] = EntityStatus.new(to_position)
	# Hooks.
	_attached(entity_rule, to_position)
	# Everything ok.
	return _Response.succeed(null)

func _can_attach(entity_rule: _EntityRule, to_position: Vector2i) -> bool:
	return bypass or entities_rule.can_attach(entity_rule, to_position)

func _attached(entity_rule: _EntityRule, to_position: Vector2i) -> void:
	entities_rule.on_entity_attached(entity_rule, to_position)
	entity_rule.trigger_on_attached(self, to_position)

## Detaches an entity from the current rule.
func detach(entity: _Entity) -> _Response:
	var entity_rule: _EntityRule = entity.entity_rule
	var e: _Exception
	# Check is attached.
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	# Get the position.
	var status: EntityStatus = _statuses[entity_rule]
	var from_position: Vector2i = status.position
	# Clear any movement.
	_movement_manager.cancel_movement(_get_object_for_entity(entity))
	# Hooks.
	entities_rule.on_entity_detached(entity_rule, from_position)
	_statuses.erase(entity_rule)
	entity_rule.trigger_on_detached()
	# Everything ok.
	return _Response.succeed(null)

# Callback for when a movement has started.
func _on_movement_started_callback(obj, direction, start_position, end_position):
	var entity_rule: _EntityRule = _get_entity_for_object(obj).entity_rule
	var status: EntityStatus = _statuses[entity_rule]
	_movement_started(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementStartedStage.Begin
	)
	status._movement = direction
	_movement_started(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementStartedStage.MovementAllocated
	)
	entity_rule.trigger_on_movement_started(
		start_position, end_position, direction
	)
	_movement_started(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementStartedStage.End
	)

# Callback for when a movement has been rejected.
func _on_movement_rejected_callback(
	obj, direction, start_position, end_position
):
	var entity_rule: _EntityRule = _get_entity_for_object(obj).entity_rule
	var status: EntityStatus = _statuses[entity_rule]
	entities_rule.on_movement_rejected(
		entity_rule, start_position, end_position, direction
	)
	entity_rule.trigger_on_movement_rejected(
		start_position, end_position, direction
	)

## Starts a movement for an entity.
func movement_start(
	entity: _Entity,
	direction: _Direction
) -> _Response:
	var entity_rule: _EntityRule = entity.entity_rule
	var e: _Exception
	# Check is attached.
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	if direction == _Direction.NONE:
		return _Response.succeed(false)
	# Check if it can allocate a movement.
	var status: EntityStatus = _statuses[entity_rule]
	if status.movement != _Direction.NONE:
		return _Response.succeed(false)
	var position: Vector2i = status.position
	_movement_manager.start_movement(
		_get_object_for_entity(entity), position, direction
	)
	return _Response.succeed(true)

# Converts the cell point to the physical / game
# point (useful for raw positions when this applies).
func _get_point(cell: Vector2i):
	return Vector2(cell)

# Returns the appropriate signal to wait for.
# Used in the related movement manager.
func _get_frame_signal():
	return null

# Returns the object associated to an entity.
func _get_object_for_entity(entity: _Entity):
	return null

# Returns the entity associated to an object.
func _get_entity_for_object(obj) -> _Entity:
	return null

# Returns the speed associated to an object.
func _get_speed_for_object(obj) -> float:
	return 0

func _can_allocate(
	entity_rule: _EntityRule,
	position: Vector2i, direction: _Direction
) -> bool:
	return bypass or entities_rule.can_move(entity_rule, position, direction)

func _movement_started(
	entity_rule: _EntityRule,
	from_position: Vector2i, to_position: Vector2i, direction: _Direction,
	stage: _EntitiesRule.MovementStartedStage
) -> void:
	entities_rule.on_movement_started(
		entity_rule, from_position, to_position, direction, stage
	)

## Cancels an ongoing movement, if there was any.
func movement_cancel(entity: _Entity) -> _Response:
	var entity_rule: _EntityRule = entity.entity_rule
	# Check is attached.
	var e: _Exception
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	var status: EntityStatus = _statuses[entity_rule]
	# Check if can clear.
	if bypass or entities_rule.can_cancel_movement(
		entity_rule, status.movement
	):
		# Everything ok.
		_movement_manager.cancel_movement(_get_object_for_entity(entity))
		return _Response.succeed(true)
	else:
		# It cannot clear.
		return _Response.succeed(false)

func _on_movement_cancelled_callback(
	obj, direction, start_position, reverted_position
):
	var entity_rule: _EntityRule = _get_entity_for_object(obj).entity_rule
	var status: EntityStatus = _statuses[entity_rule]
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, direction,
		_EntitiesRule.MovementClearedStage.Begin
	)
	_statuses[entity_rule]._movement = _Direction.NONE
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, direction,
		_EntitiesRule.MovementClearedStage.MovementCleared
	)
	entity_rule.trigger_on_movement_cleared(
		start_position, reverted_position, direction
	)
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, direction,
		_EntitiesRule.MovementClearedStage.Begin
	)

func _on_movement_finished_callback(
	obj, direction, start_position, end_position
):
	var entity_rule: _EntityRule = _get_entity_for_object(obj).entity_rule
	var status: EntityStatus = _statuses[entity_rule]
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementConfirmedStage.Begin
	)
	status._position = end_position
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementConfirmedStage.PositionChanged
	)
	status._movement = _Direction.NONE
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementConfirmedStage.MovementCleared
	)
	entity_rule.trigger_on_movement_finished(
		start_position, end_position, direction
	)
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, direction,
		_EntitiesRule.MovementConfirmedStage.End
	)

## Teleports an entity to another position in the map.
## It can be done silently, to not trigger any event.
func teleport(
	entity: _Entity, to_position: Vector2i,
	silent: bool = false
) -> _Response:
	var entity_rule: _EntityRule = entity.entity_rule
	# Check is attached.
	var e: _Exception
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	# Check boundaries.
	var ss: Vector2i = entities_rule.size
	var s: Vector2i = entity_rule.size
	var f: Vector2i = s + to_position
	if to_position.x < 0 or to_position.y < 0 or f.x > ss.x or f.y > ss.y:
		return _Response.fail(_Exception.raise("outbound", "Position out of bounds"))

	# Start the teleport.
	var status: EntityStatus = _statuses[entity_rule]
	var position: Vector2i = status.position
	# Clear the movement.
	_movement_manager.cancel_movement(_get_object_for_entity(entity))
	# Teleport.
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.Begin
	)
	status._position = to_position
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.PositionChanged
	)
	entity_rule.trigger_on_teleported(
		position, to_position, silent
	)
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.End
	)

	# Everything ok.
	return _Response.succeed(null)

## Reports a property being updated on an entity rule.
func property_updated(
	entity: _Entity, property: String, old_value, new_value
):
	var entity_rule: _EntityRule = entity.entity_rule
	entities_rule.on_property_updated(
		entity_rule, property, old_value, new_value
	)
