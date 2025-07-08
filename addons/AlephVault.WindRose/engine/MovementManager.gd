extends Node

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

## The current movement intent. It packs the details
## of a request related to a Node2D object in a 2D
## space (a RELATIVE movement).
class Movement extends Object:
	"""
	The current movement intent. These values must
	be understood as constant, except for the speed,
	which can be changed on the fly.
	"""

	var from_position: Vector2
	var to_position: Vector2
	var direction: _Direction
	
	func _init(from_: Vector2, to_: Vector2, _direction: _Direction):
		from_position = from_
		to_position = to_
		direction = _direction

# The current movement of an entity.
# Node2D -> Movement.
var _current_movement: Dictionary = {}

# The queued movement of an entity.
# Node2D -> Movement.
var _queued_movement: Dictionary = {}

# A function to get the speed of an object. It
# has a (object) -> float signature.
var _get_speed

# A criterion that tells whether a movement can be
# performed by a specific object. This criterion
# has a (object, direction) -> bool signature.
var _can_move

# A callback that notifies when a movement was just
# started. This callback has a (object, direction,
# Vector2, Vector2) signature, with no return value.
var _movement_started

# A callback that notifies when a movement was
# cancelled. This callback has a (object, direction,
# Vector2, Vector2) signature, with no return value.
var _movement_cancelled

# A callback that notifies when a movement was
# finished. This callback has a (object, direction,
# Vector2, Vector2) signature, with no return value.
var _movement_finished

# Tests whether an object can perform a movement
# or not. If no criterion is set, returns null.
func _test_can_move(obj: Node2D, direction: _Direction) -> bool:
	if _can_move != null:
		return _can_move.call(obj, direction)
	else:
		print("_can_move is not assigned. Returning true for node:", obj)
		return true

# Notifies a movement starting on an object.
func _on_movement_started(obj: Node2D, direction: _Direction,
						  from_position: Vector2, to_position: Vector2):
	if _movement_started != null:
		_movement_started.call(obj, direction, from_position, to_position)
	else:
		print("_movement_started is not assigned. The node started moving:", obj)

# Notifies a movement cancellation on an object.
func _on_movement_cancelled(obj: Node2D, direction: _Direction,
						  from_position: Vector2, to_position: Vector2):
	if _movement_cancelled != null:
		_movement_cancelled.call(obj, direction, from_position, to_position)
	else:
		print("_movement_cancelled is not assigned. The node's movement was cancelled:", obj)

# Notifies a movement finish on an object.
func _on_movement_finished(obj: Node2D, direction: _Direction,
						   from_position: Vector2, to_position: Vector2):
	if _movement_finished != null:
		_movement_finished.call(obj, direction, from_position, to_position)
	else:
		print("_movement_finished is not assigned. The node's movement was finished:", obj)

func _init(
	get_speed: Callable,
	can_move = null,
	movement_started = null,
	movement_finished = null,
	movement_cancelled = null
) -> void:
	_get_speed = get_speed
	_can_move = can_move
	_movement_started = movement_started
	_movement_finished = movement_finished
	_movement_cancelled = movement_cancelled

## Starts a movement for an object.
func start_movement(obj: Node2D, from_: Vector2, to_: Vector2, direction: _Direction):
	"""
	Starts a movement, or queues a movement if
	another movement is already started.
	"""
	
	if obj == null or direction == _Direction.NONE:
		return
	
	if not _current_movement.has(obj):
		if not _test_can_move(obj, direction):
			return

		_current_movement[obj] = Movement.new(from_, to_, direction)
		_on_movement_started(obj, direction, from_, to_)
		_movement(obj)
	else:
		_queued_movement[obj] = Movement.new(from_, to_, direction)

func _wait_frame() -> float:
	"""
	Manually waits for the next frame and retrieves a delta.
	"""

	var t1 = Time.get_ticks_usec() / 1_000_000.0
	await get_tree().process_frame
	var t2 = Time.get_ticks_usec() / 1_000_000.0
	return t2 - t1

func _movement_step(obj: Node2D, delta: float):
	"""
	Processes the movement's delta.
	"""
	
	var speed = _get_speed.call(obj)
	var movement: Movement = _current_movement[obj]
	var next_step: Vector2 = obj.position.move_toward(
		movement.to_position, delta * speed
	)
	
	# If next_step is not target, it means it is less.
	# So we must assign the new position and stop this
	# frame (this is a normal situation).
	if next_step != movement.to_position:
		obj.position = next_step
		return
	
	# By this point, the movement has finished one single
	# step. We need to check whether there's a queued
	# next movement for the object.
	if _queued_movement.has(obj):
		# Pop the next movement.
		var next_movement = _queued_movement[obj]
		_queued_movement.erase(obj)
		_on_movement_finished(obj, movement.direction,
							  movement.from_position,
							  movement.to_position)
		
		# Return if the movement cannot be started.
		if not _test_can_move(obj, next_movement.direction):
			return
		
		# Process the next movement. Immediately continue
		# if the direction is the same.
		_current_movement[obj] = next_movement
		_on_movement_started(obj, next_movement.direction,
							 next_movement.from_position,
							 next_movement.to_position)
		if movement.direction == next_movement.direction:
			# Compute, with the same current speed, the
			# step toward the NEXT movement position.
			obj.position = obj.position.move_toward(
				next_movement.to_position, delta * speed
			)
		else:
			# Just assign the already computed next step.
			obj.position = next_step
	else:
		# Use the retrieved position.
		obj.position = next_step
		pass

func _movement(obj: Node2D):
	"""
	Processes any current movement step by step.
	"""

	obj.position = _current_movement[obj].from_position
	while true:
		if not _current_movement.has(obj):
			return
		_movement_step(obj, await _wait_frame())

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
