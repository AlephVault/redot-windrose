extends Node2D

var _layer: AlephVault__WindRose.Entities.Layer

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
@export var is_movable: bool = false;

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
		else:
			assert(false, "The speed cannot be negative")

func _ready():
	if _speed < 0:
		push_warning("The entity's speed is negative - changing it to 1.0")
		_speed = 1.0
	if _size.x <= 0 or _size.y <= 0 or _size.z <= 0:
		push_warning("The entity's size is not positive - changing it to (1, 1, 1)")
		_size = Vector3i(1, 1, 1)
	var _parent = get_parent()
	if _parent is AlephVault__WindRose.Entities.Layer:
		_layer = _parent
	request_ready()

func _exit_tree() -> void:
	_layer = null
