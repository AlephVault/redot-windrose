extends Object
## The status of an entity reveals the current
## movement taking place and the current position
## (anchored by top-left corner).

## The current position.
var _position: Vector2i

var position: Vector2i:
	get:
		return _position
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityStatus", "position"
		)

## The current movement.
var _movement: AlephVault__WindRose.Utils.DirectionUtils.Direction

var movement: AlephVault__WindRose.Utils.DirectionUtils.Direction:
	get:
		return _movement
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityStatus", "position"
		)

func _init(
	position: Vector2i
):
	_position = position
	_movement = AlephVault__WindRose.Utils.DirectionUtils.Direction.NONE 
