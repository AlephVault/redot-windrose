extends TileMap
## A Map is the functional unit of space for
## these games. It contains several layers,
## being the entities layer the most important
## one sine it holds the entities.

const _Scope = AlephVault__WindRose.Maps.Scope
const _World = AlephVault__WindRose.Maps.World
const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction

## Use an index >= 0 (unique!) to register this
## map in its parent scope.
@export var _index: int = -1
var _scope: _Scope

## Gets the current scope, if any.
var scope: _Scope:
	get:
		return _scope
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "scope"
		)

## The map size, expressed as (width, height).
@export var _size: Vector2i = Vector2i(8, 6)

## Gets the map size.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "size"
		)

## Gets another map from the same world.
## Returns null if there's no world or
## the parameters are invalid.
func get_world_map(key: String, index: int) -> AlephVault__WindRose.Maps.Map:
	if _scope == null:
		return null
	var world: _World = scope.world
	if world == null:
		return null
	return world.get_map(key, index)

## Gets another map from the same scope.
## Returns null if there's no scope or
## the parameters are invalid.
func get_scope_map(index: int) -> AlephVault__WindRose.Maps.Map:
	if _scope == null:
		return null
	return _scope.get_map(index)

## Tells whether the map is valid. This involves
## checks on data elements and also checks on
## supported configurations.
func is_valid():
	# It's not valid to have no tile_set.
	if tile_set == null:
		return false
	
	# For now, we only support SQUARE rows.
	match tile_set.tile_shape:
		TileSet.TileShape.TILE_SHAPE_SQUARE:
			match tile_set.tile_layout:
				TileSet.TileLayout.TILE_LAYOUT_STACKED:
					return true
				_:
					return false
		TileSet.TileShape.TILE_SHAPE_ISOMETRIC:
			match tile_set.tile_layout:
				TileSet.TileLayout.TILE_LAYOUT_DIAMOND_DOWN:
					return true
				TileSet.TileLayout.TILE_LAYOUT_DIAMOND_RIGHT:
					return true
				_:
					return false
		_:
			return false

## The size of tiles of this map.
var tile_size: Vector2i:
	get:
		if tile_set == null:
			return Vector2i(-1, -1)
		return tile_set.tile_size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "tile_size"
		)

## Gets a vector, in pixels, for a given
## direction's delta. Since it's a linear
## projection, it can be computed directly
## from the direction's delta regardless
## the current position.
func get_delta_vector(d: _Direction) -> Vector2i:
	return map_to_local(_DirectionUtils.get_delta(d))

func _enter_tree() -> void:
	var parent = get_parent()
	if parent is _Scope and _index >= 0 and _scope == null:
		var _result = parent._add_map(self, _index)
		if _result.is_successful():
			_scope = parent
	_size = Vector2i(max(1, _size.x), max(1, _size.y))
