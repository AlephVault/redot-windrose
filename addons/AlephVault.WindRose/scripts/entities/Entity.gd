extends Node2D

## The pause status. The object is either free to
## move / animate, animated but in-place, or paused.
enum PauseStatus { FREE, INPLACE_ANIMATED, PAUSED }

var _layer: AlephVault__WindRose.Entities.Layer

## A state meant to be "idle".
const IDLE_STATE: String = "IDLE"

## A state meant to be "moving".
const MOVING_STATE: String = "MOVING"

# The time before a queued movement expires. Used so
# the queued movement can be discarded if the user
# queued it long time before the current movement was
# about to finish. Otherwise, the user cannot repent
# the queued movement or have undesired "extra advances"
# in the current direction.
var _queued_movement_expiration: float = 0

# The queued movement, if any.
var _queued_movement: int = -1

# The number of movements executed by this entity. It
# starts in -1 so the first movement starts as 0.
# After 1 << 32, it becomes 0 again. 
var _current_movement_index: int = -1

# The maximum for movement indices.
const MAX_MOVEMENT_INDEX = 1 << 32

# The current origin, if a movement is present.
var _origin: Vector2i = Vector2i(-1, -1)

# The current target, if a movement is present.
var _target: Vector2i = Vector2i(-1, -1)

## The current layer this entity is attached to.
## This is a layer in a map.
var layer: AlephVault__WindRose.Entities.Layer:
	get:
		return _layer
	set(value):
		assert(false, "The entity layer cannot be set this way")

## The current map this entity belongs to.
## It corresponds to the current layer this
## entity is attached to.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _layer.map if _layer != null else null
	set(value):
		assert(false, "The entity map cannot be set this way")

@export var _size: Vector3i = Vector3i(1, 1, 0)

## Size stands for the size of an object.
## Movable objects should only have squared
## sizes or be conceived as non-rotating
## objects when they change directions.
## No component can be <= 0 here.
var size: Vector3i:
	get:
		return _size
	set(value):
		assert(false, "The size cannot be set this way")

## Tells whether this entity can start a movement
## or not. This is the first check of ability to
## move and other conditions may prevent it from
## actually moving.
@export var is_movable: bool = false

@export var _speed: float = 1.0

## The speed of the object, expressed in terms
## of cells / second. A speed of 0 disables the
## object to be moved, aside from other eventual
## conditions or setup.
var speed: float:
	get:
		return _speed
	set(value):
		if value >= 0:
			_speed = value
			self.speed_changed.emit(value)
		else:
			assert(false, "The speed cannot be negative")

@export var _orientation: int = 0

## The orientation of the object. This value will
## always be set.
var orientation: int:
	get:
		return _orientation
	set(value):
		if value >= 0:
			_orientation = value
			self.orientation_changed.emit(value)
		else:
			assert(false, "The orientation cannot be negative")

@export var _state: String = IDLE_STATE

## The current state of this object. This value is
## a string and typically meant to be used for when
## this object needs a visual representation.
var state: String:
	get:
		return _state
	set(value):
		if value != "":
			_state = value
			self.state_changed.emit(state)
		else:
			assert(false, "The state must be non-empty")

var _pause_status: PauseStatus = PauseStatus.FREE

## The pause status. Either Free, Paused, or in-place
## but animated.
var pause_status: PauseStatus:
	get:
		return _pause_status
	set(value):
		_pause_status = value
		self.pause_status_changed.emit(value)

## The current (x, y) position. It's retrieved from
## the map. When not in a map, returns (-1, -1).
var current_position: Vector2i:
	get:
		if map != null:
			return map.get_entity_status(self).position
		return Vector2i(-1, -1)
	set(value):
		assert(false, "The in-map position cannot be set this way")

## The current (xf, yf) position, opposite to (x, y) in
## the sense that it's the bottom-right corner instead
## of the top-left (pivot) corner.
var current_final_position: Vector2i:
	get:
		var pos = current_position
		if pos == Vector2i(1, 1):
			return pos
		return pos + self.tile_size - Vector2i(1, 1)
	set(value):
		assert(false, "The in-map final position cannot be set this way")

## The current movement. It's retrieved from the map.
## When not in a map, returns -1.
var current_movement: int:
	get:
		if map != null:
			return map.get_entity_status(self).movement
		return -1
	set(value):
		assert(false, "the movement cannot be set this way")

## The current cell size of the map.
var tile_size: Vector2i:
	get:
		if map == null:
			return Vector2i(-1, -1)
		return map.tile_size
	set(value):
		assert(false, "The tile size cannot be set this way")
	
## This signal is triggered (locally) when the object's
## orientation changes.
signal orientation_changed(orientation)

## This signal is triggered (locally) when the object's
## speed changes.
signal speed_changed(speed)

## This signal is triggered (locally) when the object's
## state changes.
signal state_changed(state)

## This signal is triggered (externally) when the entity
## was just added to the map. The map property will be
## updated by this point.
signal attached()

## This signal is triggered (externally) when the object
## was just removed from the map.
signal detached()

## This signal is triggered (externally) when the object
## started moving.
signal movement_started(direction)

## This signal is triggered (externally) when the object
## is rejected from started moving.
signal movement_rejected(direction)

## This signal is triggered (externally) when the object
## finished a single movement step.
signal movement_finished(direction)

## This signal is triggered (externally) when the object
## cancelled the current movement step, if any. In this
## signal, direction can be <= 0 if no movement was made
## by that point.
signal movement_cancelled(direction)

## This signal is triggered (externally, by the involved
## entity rule) when the said entity rule determines that
## a change on a property needs to be notified. The rule
## object will be passed, along with the updated property
## and the corresponding old and new values of it.
signal property_updated(rule, prop, old_value, new_value)

## This signal is triggerd (locally) when the pause status
## is changed.
signal pause_status_changed(pause_status)

## This signal is triggered (externally) when the object
## was teleported to a new location in the same map.
signal teleported(x, y)

func _ready():
	if _orientation < 0:
		push_warning("The entity's orientation is negative - changing it to 0")
		_orientation = 0
		self.orientation_changed.emit(self, 0)
	if _speed < 0:
		push_warning("The entity's speed is negative - changing it to 1.0")
		_speed = 1.0
		self.speed_changed.emit(self, 0)
	if _size.x <= 0 or _size.y <= 0 or _size.z <= 0:
		push_warning("The entity's size is not positive - changing it to (1, 1, 1)")
		_size = Vector3i(1, 1, 1)
	var _parent = get_parent()
	if _parent is AlephVault__WindRose.Entities.Layer:
		_layer = _parent
	request_ready()

func _exit_tree() -> void:
	_layer = null

## Attaches itself to a new map. It is an error
## if the object already belongs to a map, unless
## force is set to true (in that case, the object
## is first detached).
func attach(
	map: AlephVault__WindRose.Maps.Map,
	at: Vector2i, force: bool = false
) -> bool:
	if force:
		self.detach()
	return map.attach(self, at)

## Detaches itself from the current map, if any.
func detach() -> bool:
	if self.map:
		return self.map.detach(self)
	return false

## Teleports itself to another position in the map.
## The position must be valid in the map according
## to the entity's size as well. If silent == true,
## then teleportation will not trigger any event
## but serve as some sort of self-correction.
func teleport(to: Vector2i, silent: bool = false) -> bool:
	if not self.map and self.pause_status == PauseStatus.FREE:
		return false
	return self.map.teleport(self, to, silent)

func start_movement(
	direction: int,
	continued: bool = false,
	queue_if_moving: bool = false
):
	if self.map == null or self.pause_status != PauseStatus.FREE:
		return false
	
	if self.current_movement >= 0:
		if not queue_if_moving:
			return false
		self._queued_movement = direction
		if self._speed == 0:
			self._queued_movement_expiration = INF
		else:
			self._queued_movement_expiration = 1.0 / (self._speed * 4.0)
	elif not self.map.start_movement(self, direction):
		return false
	else:
		_origin = self.map.map_to_local(current_position)
		# Notes: By this point, current_movement will be == direction
		_target = self.map.map_to_local(current_position + self.map.get_delta(self.current_movement))
		state = MOVING_STATE
		# Also, start fixing the position:
		position = _origin

func _check_queued_movement(time: float):
	self._queued_movement_expiration -= time
	if self._queued_movement_expiration <= 0:
		self._queued_movement_expiration = 0
		self._queued_movement = 0

## Reports a movement as cancelled. The entity will have
## its status reverted back to the beginning of the last
## movement it started (i.e. a single cell being displaced).
## Also, all the rules will reflect accordingly back to the
## beginning of that movement.
func cancel_movement() -> bool:
	if self.current_movement >= 0 and self.pause_status == PauseStatus.FREE:
		return self.map.cancel_movement(self)
	return false

## Reports a movement as finished. The entity will have
## its status updated and all the rules will reflect
## accordingly to the new position.
func finish_movement() -> bool:
	if self.current_movement >= 0 and self.pause_status == PauseStatus.FREE:
		return self.map.finish_movement(self)
	return false

## Moves according to time delta.
func _movement_tick(delta: float) -> void:
	# No map <--> no processing.
	if self.map == null:
		return
		
	# Paused will wait for the next tick.
	if self.pause_status != PauseStatus.FREE:
		return
	
	# If no movement, nothing to process here.
	if self.current_movement >= 0:
		# TODO IMPLEMENT THIS FROM WINDROSE: https://github.com/AlephVault/unity-windrose/blob/main/Runtime/Authoring/Behaviours/Entities/Objects/MapObject.cs#L333
		# TODO inside if (IsMoving) { ... }
		pass
	elif self._queued_movement >= 0:
		var qm: int = self._queued_movement
		self._queued_movement = -1
		self.start_movement(qm)
		_origin = position
		# Notes: By this point, current_position will be up to date.
		# Same for current_movement.
		_target = self.map.map_to_local(current_position + self.map.get_delta(self.current_movement))
		state = MOVING_STATE
	else:
		# Not moving, now.
		state = IDLE_STATE
	
	# Then, expire the queued movement if any.
	self._check_queued_movement(delta)


func _process(delta: float) -> void:
	_movement_tick(delta)
