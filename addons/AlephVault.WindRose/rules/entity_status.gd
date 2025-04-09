extends Object
## The status of an entity reveals the current
## movement taking place and the current position
## (anchored by top-left corner).

## The current position.
var position: Vector2i

## The current movement.
var movement: AlephVault__WindRose.Utils.DirectionUtils.Direction

func _init(
	_position: Vector2i
):
	position = _position
	movement = AlephVault__WindRose.Utils.DirectionUtils.Direction.NONE 
