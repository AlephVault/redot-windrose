extends AlephVault__WindRose.Maps.Layers.Layer
## This is a visuals layer. It will have the visual
## elements related to each MapEntity object in the
## map it belongs to.

## A sub-layer for this visuals layer.
class SubLayer extends Node2D:
	pass

# Whether it's initialized or not.
var _initialized: bool = false

## Whether it's initialized or not.
var initialized: bool:
	get:
		return _initialized
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"VisualsLayer", "initialized"
		)

# The initialized sub-layers of this layer.
var _sub_layers: Array[SubLayer] = []

# The callback to get the effective level for the
# coordinates of the entity.
var _get_level: Callable

# The callback to get the effective sub-level for
# the coordinates of the entity and the current
# level computed in the other callback.
var _get_sub_level: Callable

## Initializes this visuals layer (e.g. the size
## and sub-layers associated to this visuals layer
## and the proper amount of levels).
func initialize():
	if not _map:
		return
	
	if not _initialized:
		if _map.layout.layout_type == _map._MapLayoutType.INVALID:
			return
		_initialized = true
		var L: int = 0
		var l: Callable
		# var L_: Callable
		var l_: Callable
		match _map.layout.layout_type:
			_map._MapLayoutType.ORTHOGONAL:
				L = _map.size.y
				l = func(e):
					return e.cell.y
				# L_ = func(for_l):
				# 	return _map.size.x
				l_ = func(for_l, e):
					return e.cell.x
			_map._MapLayoutType.ISOMETRIC_TOPDOWN:
				L = _map.size.x + _map.size.y - 1
				l = func(e):
					return e.cell.x + e.cell.y
				# L_ = func(for_l):
				# 	return min(for_l, L - 1 - for_l, _map.size.x, _map.size.y)
				l_ = func(for_l, e):
					return min(e.cell.x, _map.size.y - 1 - e.cell.y)
			_map._MapLayoutType.ISOMETRIC_LEFTRIGHT:
				L = _map.size.x + _map.size.y - 1
				l = func(e):
					return e.cell.y - e.cell.x + _map.size.x
				# L_ = func(for_l):
				# 	return min(for_l, L - 1 - for_l, _map.size.x, _map.size.y)
				l_ = func(for_l, e):
					return min(e.cell.x, e.cell.y)
		_get_level = l
		_get_sub_level = l_
		_sub_layers.clear()
		for index in range(L):
			var node = SubLayer.new()
			node.name = "SubLevel-" + str(index)
			_sub_layers.append(node)
			add_child(node)
			node.position = Vector2(0, 0)

## We leave the _z_index in 50 here, explicitly.
## We leave space for few layers under the feet
## of the characters.
func _z_index() -> int:
	return 50
