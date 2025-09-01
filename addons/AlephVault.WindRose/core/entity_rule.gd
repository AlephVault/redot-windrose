extends Object
## An EntityRule contains data and references
## the related entity. It is the counterpart
## of an EntitiesRule.

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _EntitiesRule = AlephVault__WindRose.Core.EntitiesRule
const _EntitiesManager = AlephVault__WindRose.Core.EntitiesManager

## The set of signals used to notify an entity.
class Signals:
	## Signal telling the entity was attached to an entities manager / universe.
	signal on_attached(entities_manager: _EntitiesManager, to_position: Vector2i)
	## Signal telling the entity was detached from its entities manager / universe.
	signal on_detached()
	## Signal telling a movement started.
	signal on_movement_started(
		from_position: Vector2i, to_position: Vector2i, direction: _Direction
	)
	## Signal telling a movement was rejected.
	signal on_movement_rejected(
		from_position: Vector2i, to_position: Vector2i, direction: _Direction
	)
	## Signal telling a movement was finished.
	signal on_movement_finished(
		from_position: Vector2i, to_position: Vector2i, direction: _Direction
	)
	## Signal telling a movement was cancelled.
	signal on_movement_cancelled(
		from_position: Vector2i, reverted_position: Vector2i,
		direction: _Direction
	)
	signal _on_teleported_internal(
		from_position: Vector2i, to_position: Vector2i
	)
	## Signal telling a teleport occurred.
	signal on_teleported(
		from_position: Vector2i, to_position: Vector2i
	)

## A signal telling that a property was updated.
signal on_property_updated(property: String, old, new)

var _size: Vector2i
var _signals: Signals

## Returns the size for this rule.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "size"
		)

## Returns the signals set for this rule.
var signals: Signals:
	get:
		return _signals
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "signals"
		)

func _init(size: Vector2i, root: bool = true):
	_size = Vector2i(max(size.x, 1), max(size.y, 1))
	if root:
		_signals = Signals.new()

## Triggers the on_attached event.
func trigger_on_attached(entities_manager: _EntitiesManager, to_position: Vector2i):
	if _signals != null:
		_signals.on_attached.emit(entities_manager, to_position)

## Triggers the on_detached event.
func trigger_on_detached():
	if _signals != null:
		_signals.on_detached.emit()

## Triggers the on_movement_rejected event.
func trigger_on_movement_rejected(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	if _signals != null:
		_signals.on_movement_rejected.emit(
			from_position, to_position, direction
		)

## Triggers the on_movement_started event.
func trigger_on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	if _signals != null:
		_signals.on_movement_started.emit(
			from_position, to_position, direction
		)

## Triggers the on_movement_finished event.
func trigger_on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	if _signals != null:
		_signals.on_movement_finished.emit(
			from_position, to_position, direction
		)

## Triggers the on_movement_cleared event. Reverted
## position will be (-1, -1) if there was no movement.
func trigger_on_movement_cleared(
	from_position: Vector2i, reverted_position: Vector2i, direction: _Direction
):
	if _signals != null:
		_signals.on_movement_cancelled.emit(
			from_position, reverted_position, direction
		)

## Triggers the on_teleported event.
func trigger_on_teleported(
	from_position: Vector2i, to_position: Vector2i, silent: bool
):
	if _signals != null:
		_signals._on_teleported_internal.emit(from_position, to_position)
		if not silent:
			_signals.on_teleported.emit(from_position, to_position)

## This is a protected method designed to be used by
## subclasses of this parent class.
func _property_was_updated(property: String, old, new) -> void:
	on_property_updated.emit(property, old, new)
