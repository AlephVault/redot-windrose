extends Node2D

var _layer: AlephVault__WindRose.Entities.Layer

## A state meant to be "idle".
const IDLE_STATE: String = "IDLE"

## A state meant to be "moving".
const MOVING: String = "MOVING"

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
