extends Object

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response

func _default_merger(top, bottom):
	return top

# Gets the custom data from a cell and
# a specific layer.
func _get_tile_layer_data(
	map: TileMap, layer: int, pos: Vector2i, property: String,
	default = null
):
	var data = map.get_cell_tile_data(layer, pos)
	if not data:
		return default
	if data.has_custom_data(property):
		return data.get_custom_data(property)
	return default

# Traverses the layers in a given position
# and retrieves the value for a given property.
func _get_tile_data(
	map: TileMap, pos: Vector2i, property: String,
	default, merger: Callable
):
	var count = map.get_layers_count()
	var data = _get_tile_layer_data(map, 0, pos, property, default)
	for layer_id in range(1, count):
		var data_ = _get_tile_layer_data(map, 0, pos, property, default)
		data = merger.call(data_, data)
	return data
