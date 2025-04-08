extends TileMap

## The movement constants that are supported
## by the current version of Map.
class Movement:
	class Square:
		const DOWN: int = 0
		const LEFT: int = 1
		const RIGHT: int = 2
		const UP: int = 3

## Entity status refers to the status of the
## entities inside the map. This only involves
## the current position and the movement, if
## any (if movement < 0, then there's no current
## movement).
class EntityStatus:
	## The x position, considering the pivot
	## to be the top-left corner of the entity.
	var x: int

	## The y position, considering the pivot
	## to be the top-left corner of the entity.
	var y: int
	
	## The movement, if any.
	var movement: int
	
	## Whether there's a current movement.
	func is_moving() -> bool:
		return self.movement >= 0

@export var _size: Vector2i = Vector2i(8, 6)

## The size of the map, expressed in cells.
## Other actual tiles server aesthetic purposes
## only and do not serve for placing entities.
var size: Vector2i:
	get:
		return _size
	set(value):
		assert(false, "The size cannot be set this way")

## Tells whether the map is valid. This involves
## checks on data elements and also checks on
## supported configurations.
func is_valid():
	# It's not valid to have no tile_set.
	if tile_set == null:
		return false
	
	# For now, we only support SQUARE rows.
	if tile_set.tile_shape != TileSet.TileShape.TILE_SHAPE_SQUARE:
		return false

	# Otherwise, it's supported.
	return true

## Tells a specific unit vector. Unit vectors are
## intended to define the movement one cell at a
## time (many consecutive vectors imply a full
## movement). The delta is expressed in cells,
## both vertical and horizontal.
func get_delta(index: int) -> Vector2i:
	# HINT: map_to_local(Vector2i) returns a result
	# in pixels, where the reference pixel is the
	# top-left local pixel in the current object.
	# This requires a better alignment process in
	# the images used inside objects in this map.
	#
	# It will return 0 if no tile_set is set.
	if tile_set == null:
		return Vector2i(0, 0)
	
	match tile_set.tile_shape:
		TileSet.TileShape.TILE_SHAPE_SQUARE:
			var size: Vector2i = tile_set.tile_size
			match index:
				Movement.Square.DOWN:
					return Vector2i(0, 1)
				Movement.Square.LEFT:
					return Vector2i(-1, 0)
				Movement.Square.RIGHT:
					return Vector2i(1, 0)
				Movement.Square.UP:
					return Vector2i(0, -1)
				_:
					return Vector2i(0, 0)
		_:
			return Vector2i(0, 0)

func _ready():
	if _size.x <= 0 or _size.y <= 0:
		push_warning("The map's size is not positive - changing it to (8, 6)")
		_size = Vector2i(8, 8)
