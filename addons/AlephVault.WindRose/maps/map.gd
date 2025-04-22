@tool
extends Node2D
## A Map is the functional unit of space for
## these games. It contains several layers,
## being the entities layer the most important
## one sine it holds the entities.

const _Scope = AlephVault__WindRose.Maps.Scope
const _World = AlephVault__WindRose.Maps.World
const _DirectionUtils = AlephVault__WindRose.Utils.DirectionUtils
const _Direction = _DirectionUtils.Direction
const _FloorLayer = AlephVault__WindRose.Maps.Layers.FloorLayer

## Use an index >= 0 (unique!) to register this
## map in its parent scope.
@export_category("Identity")
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
@export_category("Topology")
@export var _size: Vector2i = Vector2i(8, 6)

## Gets the map size.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "size"
		)

@export_category("Debug")
@export var _gizmo_x_axis_color: Color = Color.RED
@export var _gizmo_y_axis_color: Color = Color.BLUE
@export var _gizmo_grid_color: Color = Color.YELLOW

# The Floor layer
var _floor_layer: _FloorLayer

## Retrieves the Floor layers.
var floor_layer: _FloorLayer:
	get:
		return _floor_layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "floor_layer"
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

# Identifies the layers recognized in
# this map (directly from the children).
func _identify_layers():
	for child in get_children():
		if child is _FloorLayer:
			_floor_layer = child

# On tree enter it registers a new index
# in the parent scope (if the parent is
# a scope).
func _enter_tree() -> void:
	var parent = get_parent()
	if parent is _Scope and _index >= 0 and _scope == null:
		var _result = parent._add_map(self, _index)
		if _result.is_successful():
			_scope = parent
	_size = Vector2i(max(1, _size.x), max(1, _size.y))
	child_order_changed.connect(_identify_layers)
	_identify_layers()

# On tree exit releases the _identify_layers
# hook (so it can connect lat).
func _exit_tree() -> void:
	child_order_changed.disconnect(_identify_layers)
	
# The draw hook in the map
func _draw() -> void:
	# First, ensure there's a TileMapLayer.
	if _floor_layer == null or _floor_layer.get_tilemaps_count() == 0:
		return
	var tile_map = _floor_layer.get_tilemap(0)

	var s: Vector2i = size
	var s00: Vector2i = tile_map.map_to_local(Vector2i(0, 0))
	var s01: Vector2i = tile_map.map_to_local(Vector2i(0, 1))
	var s10: Vector2i = tile_map.map_to_local(Vector2i(1, 0))
	var dx: Vector2i = s10 - s00
	var dy: Vector2i = s01 - s00
	var lx: Vector2i = dx * s.x
	var ly: Vector2i = dy * s.y
	var cx: Color = _gizmo_x_axis_color
	var cy: Color = _gizmo_y_axis_color
	var c_: Color = _gizmo_grid_color
	var tdy: Vector2i = Vector2i(0, 0)
	var tdx: Vector2i = Vector2i(0, 0)
	for y in range(1, s.y + 1):
		# logical y
		tdy += dy
		draw_line(s00 + tdy, s00 + tdy + lx, c_)
	for x in range(1, s.x + 1):
		# logical x
		tdx += dx
		draw_line(s00 + tdx, s00 + tdx + ly, c_)
	# logical y=0
	draw_line(s00, s00 + lx, cx)
	# logical x=0
	draw_line(s00, s00 + ly, cy)

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
