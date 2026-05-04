extends Node2D

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

@onready var _person: AlephVault__WindRose.Maps.MapEntity = %Person as AlephVault__WindRose.Maps.MapEntity

func _move(direction: _Direction):
	"""
	Moves the sample person in a given direction.
	"""

	if _person == null or direction == _Direction.NONE:
		return

	_person.start_movement(direction)

func _process(_delta):
	if Input.is_key_pressed(KEY_C):
		_person.cancel_movement()
	if Input.is_key_pressed(KEY_UP):
		_move(_Direction.UP)
	if Input.is_key_pressed(KEY_DOWN):
		_move(_Direction.DOWN)
	if Input.is_key_pressed(KEY_LEFT):
		_move(_Direction.LEFT)
	if Input.is_key_pressed(KEY_RIGHT):
		_move(_Direction.RIGHT)
