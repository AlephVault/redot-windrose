extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _EntityRule = AlephVault__WindRose.Rules.EntityRule
const _EntitiesRule = AlephVault__WindRose.Rules.EntitiesRule
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

## Whether to bypass any veto or not. Useful
## for online games, where the truth is in the
## server and not here.
@export var bypass: bool = false

## Gets the current status for an entity rule.
func get_status_for(entity_rule: _EntityRule):
	return _statuses.get(entity_rule)

func _require_not_attached(entity_rule: _EntityRule) -> _Exception:
	if _statuses.has(entity_rule):
		return _Exception.raise("already_attached", "The entity is already attached")
	return null

func _require_attached(entity_rule: _EntityRule) -> _Exception:
	if _statuses.has(entity_rule):
		return _Exception.raise("not_attached", "The entity is not attached")
	return null

## Construction takes the entities layer and
## keeps also the associated rule
func _init(entities_rule: _EntitiesRule) -> void:
	_entities_rule = entities_rule

## Initializes its state (and also the data of
## the underlying rule).
func initialize() -> void:
	entities_rule.initialize()

## Attaches an entity to the current rule.
func attach(entity_rule: _EntityRule, to_position: Vector2i) -> _Response:
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
	return null

func _can_attach(entity_rule: _EntityRule, to_position: Vector2i) -> bool:
	return bypass or entities_rule.can_attach(entity_rule, to_position)

func _attached(entity_rule: _EntityRule, to_position: Vector2i) -> void:
	entities_rule.on_entity_attached(entity_rule, to_position)
	entity_rule.trigger_on_attached(_entities_rule, to_position)

## Detaches an entity from the current rule.
func detach(entity_rule: _EntityRule) -> _Response:
	var e: _Exception
	# Check is attached.
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	# Get the position.
	var status: EntityStatus = _statuses[entity_rule]
	var from_position: Vector2i = status.position
	# Clear any movement.
	_clear_movement(entity_rule)
	# Hooks.
	entities_rule.on_entity_detached(entity_rule, from_position)
	_statuses.erase(entity_rule)
	entity_rule.trigger_on_detached(_entities_rule, from_position)
	# Everything ok.
	return _Response.succeed(null)

## Starts a movement for an entity.
func movement_start(
	entity_rule: _EntityRule,
	direction: _Direction, continued: bool
) -> _Response:
	var e: _Exception
	# Check is attached.
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	# Check if it can allocate a movement.
	var status: EntityStatus = _statuses[entity_rule]
	var position: Vector2i = status.position
	var end_position: Vector2i = position + _DirectionUtils.get_delta(direction)
	if not _can_allocate(
		entity_rule, position, direction, continued
	):
		entities_rule.on_movement_rejected(
			entity_rule, position, end_position, direction
		)
		entity_rule.trigger_on_movement_rejected(
			position, end_position, direction
		)
		return _Response.succeed(false)
	# Do the movement start.
	_movement_started(
		entity_rule, position, end_position, direction,
		_EntitiesRule.MovementStartedStage.Begin
	)
	status._movement = direction
	_movement_started(
		entity_rule, position, end_position, direction,
		_EntitiesRule.MovementStartedStage.MovementAllocated
	)
	entity_rule.trigger_on_movement_started(
		position, end_position, direction
	)
	_movement_started(
		entity_rule, position, end_position, direction,
		_EntitiesRule.MovementStartedStage.End
	)
	return _Response.succeed(true)

func _can_allocate(
	entity_rule: _EntityRule,
	position: Vector2i, direction: _Direction, continued: bool
) -> bool:
	return bypass or entities_rule.can_move(entity_rule, position, direction, continued)

func _movement_started(
	entity_rule: _EntityRule,
	from_position: Vector2i, to_position: Vector2i, direction: _Direction,
	stage: _EntitiesRule.MovementStartedStage
) -> void:
	entities_rule.on_movement_started(
		entity_rule, from_position, to_position, direction, stage
	)

## Cancels an ongoing movement, if there was any.
func movement_cancel(entity_rule: _EntityRule) -> _Response:
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
		_clear_movement(entity_rule)
		return _Response.succeed(true)
	else:
		# It cannot clear.
		return _Response.succeed(false)

# Clears any pending movement.
func _clear_movement(entity_rule: _EntityRule):
	var status: EntityStatus = _statuses[entity_rule]
	var movement: _Direction = status.movement
	var start_position: Vector2i = status.position
	var reverted_position: Vector2i = start_position + _DirectionUtils.get_delta(movement)
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, movement,
		_EntitiesRule.MovementClearedStage.Begin
	)
	_statuses[entity_rule].movement = _Direction.NONE
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, movement,
		_EntitiesRule.MovementClearedStage.MovementCleared
	)
	entity_rule.trigger_on_movement_cleared(
		start_position, reverted_position, movement
	)
	entities_rule.on_movement_cancelled(
		entity_rule, start_position, reverted_position, movement,
		_EntitiesRule.MovementClearedStage.Begin
	)

## Marks a movement as finished, when effectively
## was terminated by the movement engine itself.
## Objects report this as a way to actually mark
## their movement as finished.
func movement_finish(entity_rule: _EntityRule) -> _Response:
	# Check is attached.
	var e: _Exception
	e = _require_attached(entity_rule)
	if e:
		return _Response.fail(e)
	var status: EntityStatus = _statuses[entity_rule]
	# Check it's moving.
	if status.movement == _Direction.NONE:
		return _Response.succeed(false)
	# Finishes the movement.
	var start_position: Vector2i = status.position
	var movement: _Direction = status.movement
	var end_position: Vector2i = start_position + _DirectionUtils.get_delta(movement)
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, movement,
		_EntitiesRule.MovementConfirmedStage.Begin
	)
	status.position = end_position
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, movement,
		_EntitiesRule.MovementConfirmedStage.PositionChanged
	)
	status.movement = _Direction.NONE
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, movement,
		_EntitiesRule.MovementConfirmedStage.MovementCleared
	)
	entity_rule.trigger_on_movement_finished(
		start_position, end_position, movement
	)
	entities_rule.on_movement_finished(
		entity_rule, start_position, end_position, movement,
		_EntitiesRule.MovementConfirmedStage.End
	)
	# Everything ok.
	return _Response.succeed(true)

## Teleports an entity to another position in the map.
## It can be done silently, to not trigger any event.
func teleport(
	entity_rule: _EntityRule, to_position: Vector2i,
	silent: bool = false
) -> _Response:
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
	_clear_movement(entity_rule)
	# Teleport.
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.Begin
	)
	status.position = to_position
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.PositionChanged
	)
	if not silent:
		entity_rule.trigger_on_teleported(
			position, to_position
		)
	entities_rule.on_teleported(
		entity_rule, position, to_position,
		_EntitiesRule.TeleportedStage.End
	)

	# Everything ok.
	return _Response.succeed(null)

## Reports a property being updated on an entity rule.
func property_updated(
	entity_rule: _EntityRule,
	property: String, old_value, new_value
):
	entities_rule.on_property_updated(
		entity_rule, property, old_value, new_value
	)
