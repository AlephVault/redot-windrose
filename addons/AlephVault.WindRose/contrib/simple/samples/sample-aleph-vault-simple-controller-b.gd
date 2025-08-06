extends Node2D

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

var _selected: int = -1
var _current: AlephVault__WindRose.Maps.MapEntity = null
var _options: Array[AlephVault__WindRose.Maps.MapEntity]
var _change_pressed: bool = false
var _switch_pressed: bool = false

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
	
	_options[_selected].attach(%Map11, Vector2i(
		%Map11.size.x - 2, %Map11.size.y - 2
	))
	_current = _options[_selected]

func _switch_navigability():
	"""
	Switches the navigability from 0 to 1 and vice versa.
	"""
	
	if _current != null:
		_current.rule.navigability_rule.navigability = 1 - _current.rule.navigability_rule.navigability

func _move(direction: _Direction):
	"""
	Moves the current character in a given direction.
	"""
	
	if _current == null or direction == _Direction.NONE:
		return
	
	_current.start_movement(direction)

func _ready():
	_options = [
		%Character11b, %Character12b, %Character21b, %Character22b
	]

func _process(delta):
	if Input.is_key_pressed(KEY_E):
		if not _change_pressed:
			_change_character()
		_change_pressed = true
	else:
		_change_pressed = false
	
	if Input.is_key_pressed(KEY_R):
		if not _switch_pressed:
			_switch_navigability()
		_switch_pressed = true
	else:
		_switch_pressed = false
	
	if Input.is_key_pressed(KEY_T):
		if _current:
			_current.cancel_movement()
	if Input.is_key_pressed(KEY_W):
		_move(_Direction.UP)
	if Input.is_key_pressed(KEY_S):
		_move(_Direction.DOWN)
	if Input.is_key_pressed(KEY_A):
		_move(_Direction.LEFT)
	if Input.is_key_pressed(KEY_D):
		_move(_Direction.RIGHT)
