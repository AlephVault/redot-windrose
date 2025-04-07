extends TileMap

## The movement constants that are supported
## by the current version of Map.
class Movement:
	class Square:
		const DOWN: int = 0
		const LEFT: int = 1
		const RIGHT: int = 2
		const UP: int = 3

var size: Vector2i = Vector2i(8, 6):
	get:
		return size
	set(value):
		pass

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
