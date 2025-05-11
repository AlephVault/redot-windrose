extends AlephVault__WindRose.Core.EntitiesRule
## A Layer's EntitiesRule is an EntitiesRule that
## holds a reference to the related layer.

const _Layer = AlephVault__WindRose.Entities.Layer

var _layer: _Layer

## Returns the current layer.
var layer: _Layer:
	get:
		return _layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "layer"
		)

func _init(layer: _Layer) -> void:
	_layer = layer
