extends AlephVault__WindRose.Core.EntitiesRule
## This is an implementation of an entities rule
## where the cells can be flagged as being a static
## obstacle to all the present objects in the map.
## This means that, for an entity, its position, and
## a desired direction, the entity cannot move if any
## of the upcomming cells are considered obstacles.
##
## For a cell to be considered an obstacle, it has to
## have the topmost cell with tile having a "blocking"
## (it's name) having a boolean value of `true`.

## The data layer to use.
const DATA_LAYER: String = "blocking"

# The map this rule is related to.
var _map: AlephVault__WindRose.Maps.Map

# The blocks bitmap.
var _blocks: Array[bool]

## The map this rule is related to.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "map"
		)

# Tells whether a cell is blocking.
func _get_blocking_from_layer(floor: TileMapLayer, cell: Vector2i):
	var data = floor.get_cell_tile_data(cell)
	if data == null:
		return null
	var blocking = data.get_custom_data(DATA_LAYER)
	if not (blocking is bool):
		return null
	return blocking

func _get_blocking(cell: Vector2i) -> bool:
	var layer = map.floor_layer
	if layer == null:
		return false
	var count = layer.get_tilemaps_count()
	for index in range(count, 0, -1):
		var blocking = _get_blocking_from_layer(layer.get_tilemap(index - 1), cell)
		if blocking is bool:
			return blocking
	return false

## Initializes the cell data structure,
## by creating a bitmap array with the
## blocking flags.
func initialize_global_data():
	_blocks = []
	_blocks.resize(size.x * size.y)

## Initializes a cell's data for this rule. This
## is done by checking the data layer named "blocking"
## and returning the boolean value there.
func initialize_cell_data(cell: Vector2i) -> void:
	update_cell_data(cell)

## Updates a cell's data for this rule. This
## is done by checking the data layer named "blocking"
## and returning the boolean value there.
func update_cell_data(cell: Vector2i) -> void:
	_blocks[cell.x + cell.y * size.x] = _get_blocking(cell)

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the dumb peer blocking rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Blocking.EntityRule

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
				if _blocks[cell.x + cell.y * size.x]:
					return false
			return true
		_Direction.DOWN:
			# precondition: y < ES_H - E_H
			for x_ in range(0, entity_rule.size.x):
				var cell = Vector2i(x_ + position.x, position.y + entity_rule.size.y)
				if _blocks[cell.x + cell.y * size.x]:
					return false
			return true
		_Direction.LEFT:
			# precondition: x > 0
			for y_ in range(0, entity_rule.size.y):
				var cell = Vector2i(position.x - 1, y_ + position.y)
				if _blocks[cell.x + cell.y * size.x]:
					return false
			return true
		_Direction.RIGHT:
			# precondition: x < ES_W - E_W
			for y_ in range(0, entity_rule.size.y):
				var cell = Vector2i(position.x + entity_rule.size.x, y_ + position.y)
				if _blocks[cell.x + cell.y * size.x]:
					return false
			return true
	return false

## Construction takes the map. This one is used
## to get information from textures.
func _init(map: AlephVault__WindRose.Maps.Map):
	_map = map
	super._init(map.size)
