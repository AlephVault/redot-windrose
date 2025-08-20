extends Object

const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction

## The layout type being detected in a related
## tilemap layer. This is detected, and only a
## limited set of combinations are accepted,
## while others are deemed invalid.
enum MapLayoutType {
	## The Orthogonal layout corresponds to the
	## SQUARE tile type setting. Layout/Offset
	## settings are ignored.
	ORTHOGONAL,

	## The Isometric Top-Down layout corresponds
	## to the Isometric setting with the Diamond
	## Down layout. Offset is ignored.
	ISOMETRIC_TOPDOWN,
	
	## The Isometric Left-Right layout corresponds
	## to the Isometric setting with the Diamons
	## Right layout. Offset is ignored.
	ISOMETRIC_LEFTRIGHT,
	
	## Any other configuration is deemed invalid.
	INVALID
}

const INVALID_TRANSFORM: Transform2D = Transform2D(
	Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO
)

## The layout tracks the proper transform to use
## to understand the steps.
class MapLayout:
	# The layer to link to.
	var _tilemap_layer: TileMapLayer
	
	# The layout type to use.
	var _layout_type: MapLayoutType
	
	# The offset to use for the grid rendering,
	# and the movement of the objects in the map.
	var _grid_offset: Vector2i
	
	# The offset to subtract to the objects in
	# the map.
	var _object_offset: Vector2i

	# The size of the cell.
	var _cell_size: Vector2i

	# The (linear) transform for the layouts.
	var _transform: Transform2D
	
	# A callable to compute local-to-map.
	var _ltm: Callable
	
	# A reference to the last tile shape being used.
	# It will be null the first time.
	var _last_shape = null
	
	# A reference to the last tile layout being used.
	# It will be null the first time.
	var _last_layout = null

	## The layout type.
	var layout_type: MapLayoutType:
		get:
			return _layout_type
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapLayout", "layout_type"
			)
	
	## The offset (used for pivoting the grid painting).
	var grid_offset: Vector2i:
		get:
			return _grid_offset
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapLayout", "grid_offset"
			)
	
	## The cell size.
	var cell_size: Vector2i:
		get:
			return _cell_size
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapLayout", "cell_size"
			)
	
	## The transform for the steps.
	var transform: Transform2D:
		get:
			return _transform
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapLayout", "transform"
			)
	
	func _invalid(assertion: String):
		_transform = INVALID_TRANSFORM
		_layout_type = MapLayoutType.INVALID
		_grid_offset = Vector2i.ZERO
		assert(false, assertion)

	func _init(layer: TileMapLayer):
		## First, check the tile_set is available.
		if layer == null or layer.tile_set == null:
			_invalid("Null or unset TileMapLayer object")
			return

		_tilemap_layer = layer
		recompute()

	func recompute():
		if _tilemap_layer == null:
			return
		
		var tile_set = _tilemap_layer.tile_set
		var tile_size = tile_set.tile_size
		
		if _last_layout == tile_set.tile_layout and _last_shape == tile_set.tile_shape:
			return
		_last_layout = tile_set.tile_layout
		_last_shape = tile_set.tile_shape
		_object_offset = tile_size / 2
		
		## Then, check the cell type and size.
		match tile_set.tile_shape:
			TileSet.TileShape.TILE_SHAPE_SQUARE:
				_layout_type = MapLayoutType.ORTHOGONAL
				_grid_offset = tile_size / 2
				_cell_size = tile_set.tile_size
			TileSet.TileShape.TILE_SHAPE_ISOMETRIC:
				match tile_set.tile_layout:
					TileSet.TileLayout.TILE_LAYOUT_DIAMOND_DOWN:
						_layout_type = MapLayoutType.ISOMETRIC_TOPDOWN
						_grid_offset = Vector2i(0, tile_size.y / 2)
						_cell_size = tile_set.tile_size
					TileSet.TileLayout.TILE_LAYOUT_DIAMOND_RIGHT:
						_layout_type = MapLayoutType.ISOMETRIC_LEFTRIGHT
						_grid_offset = Vector2i(tile_size.x / 2, 0)
						_cell_size = tile_set.tile_size
					_:
						_invalid("Invalid tile layout in the tile set object")
						return
			_:
				_invalid("Invalid tile shape in the tile set object")
				return

		## Now, preparing the vectors for the transform.
		var og: Vector2i = _tilemap_layer.map_to_local(Vector2i(0, 0))
		var dx: Vector2i = Vector2i(_tilemap_layer.map_to_local(Vector2i(1, 0))) - og
		var dy: Vector2i = Vector2i(_tilemap_layer.map_to_local(Vector2i(0, 1))) - og
		_ltm = _tilemap_layer.local_to_map
		_transform = Transform2D(dx, dy, og)

	## Gets a point, in coordinates space, of
	## a cell (which is pivoted by its center)
	## and perhaps + a 1-step displacement.
	func get_point(cell: Vector2i, direction: _Direction = _Direction.NONE):
		cell += _DirectionUtils.get_delta(direction)
		return Vector2i(_transform * Vector2(cell)) - _object_offset

	## Given a position, computes its cell.
	func local_to_map(point: Vector2i) -> Vector2i:
		return _ltm.call(point)
