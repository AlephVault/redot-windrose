extends Sprite2D

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

var _manager: Node2D

func _ready() -> void:
	_manager = %MovementManager

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_UP):
		_manager.start_movement(self, _Direction.UP)
	elif Input.is_key_pressed(KEY_DOWN):
		_manager.start_movement(self, _Direction.DOWN)
	elif Input.is_key_pressed(KEY_LEFT):
		_manager.start_movement(self, _Direction.LEFT)
	elif Input.is_key_pressed(KEY_RIGHT):
		_manager.start_movement(self, _Direction.RIGHT)
	elif Input.is_key_pressed(KEY_C):
		_manager.cancel_movement(self)
