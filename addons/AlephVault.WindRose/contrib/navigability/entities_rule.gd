extends AlephVault__WindRose.Core.EntitiesRule
## This entities rule subclass ensures the are many
## types of navigability for the individual cells, and
## entities can move across cells that include the
## navigability allowed for them. This allows defining
## maps with e.g. walk / surf navigabilities, so they
## allow people to walk and ships to surf.

## The data layer to use.
const NAVIGABILITY_TYPE_LAYER: String = "navigability_type"
const NAVIGABILITY_INCREMENTS_LAYER: String = "navigability_increments"

# The map this rule is related to.
var _map: AlephVault__WindRose.Maps.Map

# The navigabilities array.
var _navigability_types: Array[int]

## The map this rule is related to.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "map"
		)

var _tileset_has_incremental: Dictionary = {}

func _tilemap_layer_has_incremental_data_layer(floor: TileMapLayer) -> bool:
	var tile_set: TileSet = floor.tile_set
	if not _tileset_has_incremental.has(tile_set):
		var count: int = tile_set.get_custom_data_layers_count()
		_tileset_has_incremental[tile_set] = false
		for index in range(count):
			if tile_set.get_custom_data_layer_name(index) == NAVIGABILITY_INCREMENTS_LAYER:
				_tileset_has_incremental[tile_set] = true
				break
	return _tileset_has_incremental[tile_set]

func _get_incremental_from_layer(
	floor: TileMapLayer,
	cell: Vector2i
):
	if not _tilemap_layer_has_incremental_data_layer(floor):
		return null
	var data = floor.get_cell_tile_data(cell)
	if data == null:
		return null
	var increments = data.get_custom_data(NAVIGABILITY_INCREMENTS_LAYER)
	if not (increments is bool):
		return null
	return increments

var _tileset_has_type: Dictionary = {}

func _tilemap_layer_has_type_data_layer(floor: TileMapLayer) -> bool:
	var tile_set: TileSet = floor.tile_set
	if not _tileset_has_type.has(tile_set):
		var count: int = tile_set.get_custom_data_layers_count()
		_tileset_has_type[tile_set] = false
		for index in range(count):
			if tile_set.get_custom_data_layer_name(index) == NAVIGABILITY_INCREMENTS_LAYER:
				_tileset_has_type[tile_set] = true
				break
	return _tileset_has_type[tile_set]

func _get_type_from_layer(
	floor: TileMapLayer,
	cell: Vector2i
):
	if not _tilemap_layer_has_type_data_layer(floor):
		return null
	var data = floor.get_cell_tile_data(cell)
	if data == null:
		return null
	var type_ = data.get_custom_data(NAVIGABILITY_TYPE_LAYER)
	if not (type_ is int):
		return null
	return null

# Given the current navigability, it gets
# the navigability change for the given
# cell and combines it with the current
# navigability inferred from previous
# layers to return the final navegability.
func _get_next_navigability(
	floor: TileMapLayer,
	cell: Vector2i,
	current_navigability: int
) -> int:
	var navigability_incremental = _get_incremental_from_layer(
		floor, cell
	)
	if navigability_incremental == null:
		# The cell does not define a navigability
		# incremental flag, so we respect the current
		# value of navigability.
		return current_navigability
	var navigability_type: int = _get_type_from_layer(
		floor, cell
	)
	if navigability_type == null or (
		navigability_type < 0 or navigability_type > 63
	):
		# The cell does not define a navigability
		# type, so we respect the current value of
		# navigability (alternatively: If the value
		# of navigability is not valid, then it is
		# ignored and also the current navigability
		# value is returned).
		return current_navigability
	if navigability_incremental:
		return current_navigability | (1 << navigability_type)
	else:
		return (1 << navigability_type)

# Computes the navigability of a cell by
# running through all the related tilemaps
# and adding / replacing the navigability
# types of each cell. In the end, a perhaps
# compound number with one or more of them
# exists (by default, a navigability of 1
# is always present).
func _get_navigability(cell: Vector2i) -> int:
	var layer = map.floor_layer
	if layer == null:
		return 1
	var count = layer.get_tilemaps_count()
	# First, start the navigability at 1
	# (this means: default / "walking"
	# navigability).
	var final_navigability = 1
	for index in range(0, count):
		final_navigability = _get_next_navigability(
			layer.get_tilemap(index - 1), cell,
			final_navigability
		)
	return final_navigability

## Initializes the cell data structure,
## by creating an integer array with the
## navigability types.
func initialize_global_data():
	_navigability_types = []
	_navigability_types.resize(size.x * size.y)

## Initializes a cell's data for this rule. This
## is done by checking the data layers named
## "navigability_type" and "navigability_increments"
## and composing the navigability accordingly. From
## the bottommost to the topmost floor, the correspondingg
## cell is considered and the values for the type and
## incremental flag are considered. If the flag is true,
## then the final navigability type becomes the current
## one or-combined with (1 << navigability_type from the
## corresponding tileset for the in-cell tile). Otherwise,
## the final navigability becomes (1 << navigability_type).
func initialize_cell_data(cell: Vector2i) -> void:
	update_cell_data(cell)

## Initializes a cell's data for this rule. This
## is done by checking the data layers named
## "navigability_type" and "navigability_increments"
## and composing the navigability accordingly. From
## the bottommost to the topmost floor, the correspondingg
## cell is considered and the values for the type and
## incremental flag are considered. If the flag is true,
## then the final navigability type becomes the current
## one or-combined with (1 << navigability_type from the
## corresponding tileset for the in-cell tile). Otherwise,
## the final navigability becomes (1 << navigability_type).
func update_cell_data(cell: Vector2i) -> void:
	_navigability_types[cell.x + cell.y * size.x] = _get_navigability(cell)

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the navigability rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Navigability.EntityRule

## Tells whether an entity can start moving.
func can_move(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	position: Vector2i, direction: _Direction
) -> bool:
	match direction:
		_Direction.UP:
			# precondition: y > 0
			for x_ in range(0, entity_rule.size.x):
				var cell = Vector2i(x_ + position.x, position.y - 1)
				if (_navigability_types[cell.x + cell.y * size.x] & (1 << entity_rule.navigability_type)) == 0:
					return false
			return true
		_Direction.DOWN:
			# precondition: y < ES_H - E_H
			for x_ in range(0, entity_rule.size.x):
				var cell = Vector2i(x_ + position.x, position.y + entity_rule.size.y)
				if (_navigability_types[cell.x + cell.y * size.x] & (1 << entity_rule.navigability_type)) == 0:
					return false
			return true
		_Direction.LEFT:
			# precondition: x > 0
			for y_ in range(0, entity_rule.size.y):
				var cell = Vector2i(position.x - 1, y_ + position.y)
				if (_navigability_types[cell.x + cell.y * size.x] & (1 << entity_rule.navigability_type)) == 0:
					return false
			return true
		_Direction.RIGHT:
			# precondition: x < ES_W - E_W
			for y_ in range(0, entity_rule.size.y):
				var cell = Vector2i(position.x + entity_rule.size.x, y_ + position.y)
				if (_navigability_types[cell.x + cell.y * size.x] & (1 << entity_rule.navigability_type)) == 0:
					return false
			return true
	return false

## Construction takes the map. This one is used
## to get information from tilemap layers and
## their cells.
func _init(map: AlephVault__WindRose.Maps.Map):
	_map = map
	super._init(map.size)
