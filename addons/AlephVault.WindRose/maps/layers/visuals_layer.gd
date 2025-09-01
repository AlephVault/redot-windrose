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
		match _map.layout.layout_type:
			_map._MapLayoutType.ORTHOGONAL:
				pass
			_map._MapLayoutType.ISOMETRIC_TOPDOWN:
				pass
			_map._MapLayoutType.ISOMETRIC_LEFTRIGHT:
				pass

## We leave the _z_index in 50 here, explicitly.
## We leave space for few layers under the feet
## of the characters.
func _z_index() -> int:
	return 50
