extends Node2D

const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction

var _manager: AlephVault__WindRose.WREngine.MovementManager

var manager: AlephVault__WindRose.WREngine.MovementManager:
	get:
		return _manager
	set(value):
		pass

func _ready() -> void:
	_manager = AlephVault__WindRose.WREngine.MovementManager.new(
		(func(): return get_tree().process_frame),
		(func(obj, direction): return Vector2(_DirectionUtils.get_delta(direction)) * Vector2(32, 32)),
		(func(obj): return 64),
		(func(obj, direction): return true),
		(func(obj, direction, from_, to_): print("Starting movement:", obj, direction, from_, to_)),
		(func(obj, direction, from_, to_): print("Finishing movement:", obj, direction, from_, to_)),
		(func(obj, direction, from_, to_): print("Cancelling movement:", obj, direction, from_, to_)),
		.25
	)

func start_movement(obj: Node2D, direction: _Direction):
	return _manager.start_movement(obj, obj.position, Vector2i(obj.position) + _DirectionUtils.get_delta(direction) * Vector2i(32, 32), direction)


func cancel_movement(obj: Node2D):
	return _manager.cancel_movement(obj)


func is_moving(obj: Node2D) -> bool:
	return _manager.is_moving(obj)
