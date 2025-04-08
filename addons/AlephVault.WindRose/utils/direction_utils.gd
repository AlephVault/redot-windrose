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
static func is_valid_direction(direction: int) -> bool:
	return direction in [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]

## Returns the opposite of a given direction.
static func opposite_direction(direction: int) -> int:
	match direction:
		Direction.UP: return Direction.DOWN
		Direction.DOWN: return Direction.UP
		Direction.LEFT: return Direction.RIGHT
		Direction.RIGHT: return Direction.LEFT
		_: return Direction.NONE
