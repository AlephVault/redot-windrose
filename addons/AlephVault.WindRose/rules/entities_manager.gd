extends Object
## An EntitiesManager has a parent entities rule
## to be used and, based on it, to manage the
## state of the entities in the current map.

const _ErrorUtils = AlephVault__WindRose.Utils.ErrorUtils
const _Error = _ErrorUtils.Error
const _EntityRule = AlephVault__WindRose.Rules.EntityRule
const _EntitiesRule = AlephVault__WindRose.Rules.EntitiesRule
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

func _require_not_attached(entity_rule: _EntityRule) -> _Error:
	if _statuses.has(entity_rule):
		return _Error.new("already_attached", "The entity is already attached").raise()
	return null

func _require_attached(entity_rule: _EntityRule) -> _Error:
	if _statuses.has(entity_rule):
		return _Error.new("not_attached", "The entity is not attached").raise()
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
) -> _Error:
	var e: _Error
	# Check is not attached.
	e = _require_not_attached(entity_rule)
	if e:
		return e
	# Check allowance.
	if not _can_attach(entity_rule, to_position):
		return _Error.new("not_allowed", "Entity not allowed").raise()
	var s: Vector2i = entities_rule.size
	var f: Vector2i = s + to_position
	# Check boundaries.
	if to_position.x < 0 or to_position.y < 0 or f.x > s.x or f.y > s.y:
		return _Error.new("outbound", "Position out of bounds").raise()
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
) -> _Error:
	var e: _Error
	# Check is not attached.
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
	return null

# Clears any pending movement.
func _clear_movement(entity_rule: _EntityRule) -> void:
	pass
