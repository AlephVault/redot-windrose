extends Object

## This enum defines the possible directions for entities and map logic.
## Used both for orientation and movement purposes.
enum Direction {
	NONE = -1,
	UP = 0,
	DOWN = 1,
	LEFT = 2,
	RIGHT = 3
}

## Tells whether a direction is valid.
static func is_valid_direction(direction: Direction) -> bool:
	return direction in [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]

## Returns the opposite of a given direction.
static func opposite_direction(direction: Direction) -> Direction:
	match direction:
		Direction.UP: return Direction.DOWN
		Direction.DOWN: return Direction.UP
		Direction.LEFT: return Direction.RIGHT
		Direction.RIGHT: return Direction.LEFT
		_: return Direction.NONE

## Returns the delta of a vector, independent of
## the layout.
static func get_delta(direction: Direction) -> Vector2i:
	match direction:
		Direction.UP: return Vector2i(0, -1)
		Direction.DOWN: return Vector2i(0, 1)
		Direction.LEFT: return Vector2i(-1, 0)
		Direction.RIGHT: return Vector2i(1, 0)
		_: return Vector2i(0, 0)
