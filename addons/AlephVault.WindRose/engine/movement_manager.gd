extends Object

const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction

## A current queued movement. It holds the direction
## and the remaining timeout.
class QueuedMovement extends Object:
	"""
	A pending movement intent. It only has direction
	and timeout. The timeout is used to prune queued
	movements that lasted for that much and haven't
	been renewd by the end of the current movement.
	"""
	
	var direction: _Direction
	var expiration: float
	
	func _init(_direction: _Direction, _expiration: float):
		direction = _direction
		expiration = _expiration

## The current movement intent. It packs the details
## of a request related to a Node2D object in a 2D
## space (a RELATIVE movement).
class Movement extends Object:
	"""
	The current movement intent. These values must
	be understood as constant, except for the speed,
	which can be changed on the fly.
	"""

	var from_position: Vector2i
	var to_position: Vector2i
	var raw_from_position: Vector2
	var raw_to_position: Vector2
	var direction: _Direction
	
	func _init(
		from_: Vector2i, to_: Vector2i,
		raw_from: Vector2, raw_to: Vector2,
		_direction: _Direction
	):
		from_position = from_
		to_position = to_
		raw_from_position = raw_from
		raw_to_position = raw_to
		direction = _direction

# The current movement of an entity.
# Node2D -> Movement.
var _current_movement: Dictionary = {}

# The queued movement of an entity.
# Node2D -> QueuedMovement.
var _queued_movement: Dictionary = {}

# A function to get the speed of an object. It
# has a (object) -> float signature.
var _get_speed

# A function to get the next_frame signal. It
# has a -> signal() signature.
var _get_frame_signal

# A function to get the raw position for a given
# logical position. It has a (Vector2i) -> Vector2
# signature.
var _get_raw_position

# A criterion that tells whether a movement can be
# performed by a specific object. This criterion
# has a (object, direction) -> bool signature.
var _can_move

# A callback that notifies when a movement was just
# rejected. This callback has a (object, direction,
# Vector2i, Vector2i) signature, with no return value.
var _movement_rejected

# A callback that notifies when a movement was just
# started. This callback has a (object, direction,
# Vector2i, Vector2i) signature, with no return value.
var _movement_started

# A callback that notifies when a movement was
# cancelled. This callback has a (object, direction,
# Vector2i, Vector2i) signature, with no return value.
var _movement_cancelled

# A callback that notifies when a movement was
# finished. This callback has a (object, direction,
# Vector2i, Vector2i) signature, with no return value.
var _movement_finished

# A number of frames the queued movements will last
# for. This means that queued movements can expire
# if not "renewed" close to the end of the current
# movement and serves as a protection against press
# of keys lasting many frames and performing two
# movements instead of one due to multiple calls to
# start_movement().
var _queue_expiration

# Tests whether an object can perform a movement
# or not. If no criterion is set, returns null.
func _test_can_move(obj: Node2D, direction: _Direction) -> bool:
	if _can_move != null:
		return _can_move.call(obj, direction)
	else:
		print("_can_move is not assigned. Returning true for node:", obj)
		return true

# Notifies a movement being rejected.
func _on_movement_rejected(obj: Node2D, direction: _Direction,
						   from_position: Vector2i, to_position: Vector2i):
	if _movement_rejected != null:
		_movement_rejected.call(obj, direction, from_position, to_position)
	else:
		print("_movement_rejected is not assigned. The node could not move:", obj)

# Notifies a movement starting on an object.
func _on_movement_started(obj: Node2D, direction: _Direction,
						  from_position: Vector2i, to_position: Vector2i):
	if _movement_started != null:
		_movement_started.call(obj, direction, from_position, to_position)
	else:
		print("_movement_started is not assigned. The node started moving:", obj)

# Notifies a movement cancellation on an object.
func _on_movement_cancelled(obj: Node2D, direction: _Direction,
							from_position: Vector2i, to_position: Vector2i):
	if _movement_cancelled != null:
		_movement_cancelled.call(obj, direction, from_position, to_position)
	else:
		print("_movement_cancelled is not assigned. The node's movement was cancelled:", obj)

# Notifies a movement finish on an object.
func _on_movement_finished(obj: Node2D, direction: _Direction,
						   from_position: Vector2i, to_position: Vector2i):
	if _movement_finished != null:
		_movement_finished.call(obj, direction, from_position, to_position)
	else:
		print("_movement_finished is not assigned. The node's movement was finished:", obj)

func _init(
	get_frame_signal: Callable,
	get_raw_position: Callable,
	get_speed: Callable,
	can_move = null,
	movement_rejected = null,
	movement_started = null,
	movement_finished = null,
	movement_cancelled = null,
	queue_expiration = 5
) -> void:
	_get_frame_signal = get_frame_signal
	_get_raw_position = get_raw_position
	_get_speed = get_speed
	_can_move = can_move
	_movement_rejected = movement_rejected
	_movement_started = movement_started
	_movement_finished = movement_finished
	_movement_cancelled = movement_cancelled
	_queue_expiration = queue_expiration

## Starts a movement for an object.
func start_movement(obj: Node2D, from_: Vector2i, direction: _Direction):
	"""
	Starts a movement, or queues a movement if
	another movement is already started.
	"""

	if obj == null or direction == _Direction.NONE:
		return false

	var to_: Vector2i = from_ + _DirectionUtils.get_delta(direction)
	
	if not _current_movement.has(obj):
		if not _test_can_move(obj, direction):
			_on_movement_rejected(obj, direction, from_, to_)
			return false

		_current_movement[obj] = Movement.new(
			from_, to_, _get_raw_position.call(from_), _get_raw_position.call(to_),
			direction
		)
		_on_movement_started(obj, direction, from_, to_)
		_movement(obj)
		return true
	else:
		_queued_movement[obj] = QueuedMovement.new(direction, _queue_expiration)
		return null

func _wait_frame() -> float:
	"""
	Manually waits for the next frame and retrieves a delta.
	"""

	var t1 = Time.get_ticks_usec() / 1_000_000.0
	await _get_frame_signal.call()
	var t2 = Time.get_ticks_usec() / 1_000_000.0
	return t2 - t1

func _queued_movement_expire(obj: Node2D, delta: float):
	"""
	Expires the queued movement a while. Pops it if it is
	already expired.
	"""
	
	if not _queued_movement.has(obj):
		return
	
	var movement: QueuedMovement = _queued_movement[obj]
	movement.expiration -= delta
	if movement.expiration <= 0:
		_queued_movement.erase(obj)
	
func _movement_step(obj: Node2D, delta: float) -> bool:
	"""
	Processes the movement's delta.
	"""

	# Abort if there's no current movement.
	if not _current_movement.has(obj):
		return false
	
	# Expire any queued movement a bit.
	_queued_movement_expire(obj, delta)

	# Get the current speed and compute the next step.
	var speed = _get_speed.call(obj)
	var movement: Movement = _current_movement[obj]
	var next_step: Vector2 = obj.position.move_toward(
		movement.raw_to_position, delta * speed
	)
	
	# If next_step is not target, it means it is less.
	# So we must assign the new position and stop this
	# frame (this is a normal situation).
	if next_step != movement.raw_to_position:
		obj.position = next_step
		return true
	
	# By this point, the movement has finished one single
	# step. We need to check whether there's a queued
	# next movement for the object.
	if _queued_movement.has(obj):
		# Pop the next movement.
		var next_movement_direction = _queued_movement[obj].direction
		var next_movement_to_position = movement.to_position + _DirectionUtils.get_delta(next_movement_direction)
		var next_movement_from_position = movement.to_position
		var next_movement_raw_to_position = _get_raw_position.call(next_movement_to_position)
		var next_movement_raw_from_position = movement.raw_to_position
		_queued_movement.erase(obj)
		_on_movement_finished(obj, movement.direction,
							  movement.from_position,
							  movement.to_position)
		
		# Return if the movement cannot be started.
		if not _test_can_move(obj, next_movement_direction):
			return true
		
		# Process the next movement. Immediately continue
		# if the direction is the same.
		_current_movement[obj] = Movement.new(
			next_movement_from_position, next_movement_to_position,
			next_movement_raw_from_position, next_movement_raw_to_position,
			next_movement_direction
		)
		_on_movement_started(obj, next_movement_direction,
							 next_movement_from_position,
							 next_movement_to_position)
		if movement.direction == next_movement_direction:
			# Compute, with the same current speed, the
			# step toward the NEXT movement position.
			obj.position = obj.position.move_toward(
				next_movement_raw_to_position, delta * speed
			)
		else:
			# Just assign the already computed next step.
			obj.position = next_step
	else:
		# Use the retrieved position.
		obj.position = next_step
	return true

func _movement(obj: Node2D):
	"""
	Processes any current movement step by step.
	"""

	obj.position = _current_movement[obj].from_position
	while true:
		if not _movement_step(obj, await _wait_frame()):
			return

## Cancels a movement for an object.
func cancel_movement(obj: Node2D):
	if _current_movement.has(obj):
		var movement: Movement = _current_movement[obj]
		obj.position = movement.from_position
		_current_movement.erase(obj)
		if _queued_movement.has(obj):
			_queued_movement.erase(obj)
		_on_movement_cancelled(obj, movement.direction,
							   movement.from_position,
							   movement.to_position)

## Tells whether an object is currently moving
## or not. This is only with respect of this
## manager (the object might be being moved
## by another manager instance).
func is_moving(obj: Node2D) -> bool:
	return _current_movement.has(obj)
