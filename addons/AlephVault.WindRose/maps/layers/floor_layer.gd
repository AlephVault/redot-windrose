extends AlephVault__WindRose.Maps.Layers.Layer
## The floor layer is one containing all the
## TileMapLayer instances that matter for this
## map (it also tracks the order of tilemaps
## so the map can retrieve its data).

var _connected: bool = false
var _sorted_layers: Array[TileMapLayer] = []

# Gets the list of tilemap layers added to this floor
# layer.
func _child_order_changed():
	_sorted_layers.clear()

	for child in get_children():
		if child is TileMapLayer:
			_sorted_layers.append(child)

## Gets a tilemap layer (being 0 the background
## tilemap layer, or closest to).
func get_tilemap(index: int) -> TileMapLayer:
	return _sorted_layers[index]

## Gets the count of tilemaps added to this layer.
func get_tilemaps_count() -> int:
	return len(_sorted_layers)

func _ready():
	super._ready()
	if not _connected:
		child_order_changed.connect(_child_order_changed)
		_connected = true

## We leave the _z_index in 10 here, explicitly.
## Other ones will be, most likely, greater in
## index value (becoming frontmost).
func _z_index() -> int:
	return 10
