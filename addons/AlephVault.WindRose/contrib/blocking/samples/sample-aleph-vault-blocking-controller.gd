extends Node2D

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

var _selected: int = -1
var _current: AlephVault__WindRose.Maps.MapEntity = null
var _options: Array[AlephVault__WindRose.Maps.MapEntity]
var _change_pressed: bool = false

func _change_character():
	"""
	Switches the character to the next one, and the
	the character is added to position (0, 0) and
	then controlled (the previous character will be
	removed).
	"""

	if _current != null:
		_current.detach()
		_current = null

	_selected += 1
	if _selected == 4:
		_selected = 0
	
	_options[_selected].attach(%Map, Vector2i(0, 0))
	_current = _options[_selected]

func _move(direction: _Direction):
	"""
	Moves the current character in a given direction.
	"""
	
	if _current == null or direction == _Direction.NONE:
		return
	
	_current.start_movement(direction)

func _ready():
	_options = [
		%Character11, %Character12, %Character21, %Character22
	]

func _process(delta):
	if Input.is_key_pressed(KEY_S):
		if not _change_pressed:
			_change_character()
		_change_pressed = true
	else:
		_change_pressed = false
	
	if Input.is_key_pressed(KEY_C):
		if _current:
			_current.cancel_movement()
	if Input.is_key_pressed(KEY_UP):
		_move(_Direction.UP)
	if Input.is_key_pressed(KEY_DOWN):
		_move(_Direction.DOWN)
	if Input.is_key_pressed(KEY_LEFT):
		_move(_Direction.LEFT)
	if Input.is_key_pressed(KEY_RIGHT):
		_move(_Direction.RIGHT)
