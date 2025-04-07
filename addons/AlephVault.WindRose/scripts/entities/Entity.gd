extends Node2D

@export var _size: Vector2i = Vector2i(1, 1)

## Size stands for the size of an object.
## Movable objects should only have squared
## sizes or be conceived as non-rotating
## objects when they change directions.
## No dimension can be 0 here.
var size: Vector2i:
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
	if _size.x <= 0 or _size.y <= 0:
		push_warning("The entity's size is not positive - changing it to (1, 1)")
		_size = Vector2i(1, 1)
