extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _EntityRule = AlephVault__WindRose.Rules.EntityRule
const _EntitiesRule = AlephVault__WindRose.Rules.EntitiesRule
const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
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
func attach(
	entity_rule: _EntityRule, to_position: Vector2i
) -> _Exception:
	var e: _Exception
	# Check is not attached.
	e = _require_not_attached(entity_rule)
	if e:
		return e
	# Check allowance.
	if not _can_attach(entity_rule, to_position):
		return _Exception.raise("not_allowed", "Entity not allowed")
	var s: Vector2i = entities_rule.size
	var f: Vector2i = s + to_position
	# Check boundaries.
	if to_position.x < 0 or to_position.y < 0 or f.x > s.x or f.y > s.y:
		return _Exception.raise("outbound", "Position out of bounds")
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
	entity_rule.trigger_on_attached(to_position)

## Detaches an entity from the current rule.
func detach(
	entity_rule: _EntityRule
) -> _Exception:
	var e: _Exception
	# Check is attached.
	e = _require_attached(entity_rule)
	if e:
		return e
	# Get the position.
	var status: EntityStatus = _statuses[entity_rule]
	var from_position: Vector2i = status.position
	# Clear any movement.
	_clear_movement(entity_rule)
	# Hooks.
	entities_rule.on_entity_detached(entity_rule, from_position)
	_statuses.erase(entity_rule)
	entity_rule.trigger_on_detached(from_position)
	# Everything ok.
	return null

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
	var end_position: Vector2i = position + entities_rule.get_delta(direction)
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
	return entities_rule.can_move(entity_rule, position, direction, continued)

func _movement_started(
	entity_rule: _EntityRule,
	from_position: Vector2i, to_position: Vector2i, direction: _Direction,
	stage: _EntitiesRule.MovementStartedStage
) -> void:
	entities_rule.on_movement_started(
		entity_rule, from_position, to_position, direction, stage
	)

# Clears any pending movement.
func _clear_movement(entity_rule: _EntityRule) -> void:
	pass
