extends TileMap

## The movement constants that are supported
## by the current version of Map.
class Direction:
	class Square:
		const DOWN: int = 0
		const LEFT: int = 1
		const RIGHT: int = 2
		const UP: int = 3

## Entity status refers to the status of the
## entities inside the map. This only involves
## the current position and the movement, if
## any (if movement < 0, then there's no current
## movement).
class EntityStatus:
	## The position, considering the pivot
	## to be the top-left corner of the entity.
	var position: Vector2i
	
	## The movement, if any.
	var movement: int
	
	## Whether there's a current movement.
	func is_moving() -> bool:
		return self.movement >= 0

@export var _size: Vector2i = Vector2i(8, 6)

## The entities and their statuses.
var _entity_statuses: Dictionary

# The entities layer.
var _entities_layer: AlephVault__WindRose.Entities.Layer

var entities_layer: AlephVault__WindRose.Entities.Layer:
	get:
		return _entities_layer
	set(value):
		assert(false, "The entities layer cannot be set this way")

## Adds the truth about an entity. Its position
## and its movement (-1 initially).
func _add_entity_status(
	entity: AlephVault__WindRose.Entities.Entity,
	x: int, y: int
):
	var status = self._entity_statuses.get_or_add(entity, EntityStatus.new())
	status.position = Vector2i(x, y)
	status.movement = -1

## Removes the truth about an entity. Its position
## and its movement.
func _remove_entity_status(
	entity: AlephVault__WindRose.Entities.Entity
):
	self._entity_statuses.erase(entity)

## Returns the status of an entity.
func get_entity_status(
	entity: AlephVault__WindRose.Entities.Entity
) -> EntityStatus:
	return self._entity_statuses.get(entity)

## The size of the map, expressed in cells.
## Other actual tiles server aesthetic purposes
## only and do not serve for placing entities.
var size: Vector2i:
	get:
		return _size
	set(value):
		assert(false, "The size cannot be set this way")

## Tells whether the map is valid. This involves
## checks on data elements and also checks on
## supported configurations.
func is_valid():
	# It's not valid to have no tile_set.
	if tile_set == null:
		return false
	
	# For now, we only support SQUARE rows.
	if tile_set.tile_shape != TileSet.TileShape.TILE_SHAPE_SQUARE:
		return false

	# Otherwise, it's supported.
	return true

## The size of tiles of this map.
var tile_size: Vector2i:
	get:
		if tile_set == null:
			return Vector2i(-1, -1)
		return tile_set.tile_size
	set(value):
		assert(false, "The tile size ccannot be set this way")

## Tells a specific unit vector. Unit vectors are
## intended to define the movement one cell at a
## time (many consecutive vectors imply a full
## movement). The delta is expressed in cells,
## both vertical and horizontal.
func get_delta(index: int) -> Vector2i:
	# HINT: map_to_local(Vector2i) returns a result
	# in pixels, where the reference pixel is the
	# top-left local pixel in the current object.
	# This requires a better alignment process in
	# the images used inside objects in this map.
	#
	# It will return 0 if no tile_set is set.
	if tile_set == null:
		return Vector2i(0, 0)
	
	match tile_set.tile_shape:
		TileSet.TileShape.TILE_SHAPE_SQUARE:
			match index:
				Direction.Square.DOWN:
					return Vector2i(0, 1)
				Direction.Square.LEFT:
					return Vector2i(-1, 0)
				Direction.Square.RIGHT:
					return Vector2i(1, 0)
				Direction.Square.UP:
					return Vector2i(0, -1)
				_:
					return Vector2i(0, 0)
		_:
			return Vector2i(0, 0)

## Attaches an object to this map at a given position.
##
## This method is requested by an Entity.
func attach(
	entity: AlephVault__WindRose.Entities.Entity,
	at: Vector2i
) -> bool:
	assert(false, "IMPLEMENT attach method!!!")
	return false

## Detaches an object from this map.
##
## This method is requested by an Entity.
func detach(entity: AlephVault__WindRose.Entities.Entity) -> bool:
	assert(false, "IMPLEMENT detach method!!!")
	return false

## Teleports an entity inside the map to another position.
## The position must be valid considering the map's size
## and the entity's size as well. If silent == true, then
## teleportation will not trigger any event but serve as
## some sort of self-correction.
##
## This method is requested by an Entity.
func teleport(
	entity: AlephVault__WindRose.Entities.Entity,
	to: Vector2i, silent: bool = false
) -> bool:
	assert(false, "IMPLEMENT teleport method!!!")
	return false

## Reports the desire of starting a movement. This action
## can be vetoed by the current rules. The status and the
## rules are notified accordingly and react accordingly,
## letting or not the movement start.
##
## This method is requested by an Entity.
func start_movement(
	entity: AlephVault__WindRose.Entities.Entity,
	direction: int
) -> bool:
	if direction < 0:
		return false

	assert(false, "IMPLEMENT start_movement method!!!")
	return false

## Reports a movement cancel (an individual tile, not the full
## movement since the first user interaction). Notifies rules
## and status to revert to the beginning of that individual
## movement in particular.
##
## This method is requested by an Entity.
func cancel_movement(
	entity: AlephVault__WindRose.Entities.Entity
) -> bool:
	assert(false, "IMPLEMENT cancel_movement method!!!")
	return false

## Reports a movement finish (an individual tile, not the full
## movement which may imply several steps). Notifies the rules
## and updates the status accordingly.
##
## This method is requested by an Entity.
func finish_movement(
	entity: AlephVault__WindRose.Entities.Entity
) -> bool:
	assert(false, "IMPLEMENT finish_movement method!!!")
	return false

func _enter_tree() -> void:
	_entities_layer = null
	for c in get_children():
		if c is AlephVault__WindRose.Entities.Layer:
			assert(_entities_layer == null, "An Entities.Layer is already assigned to this map")
			if _entities_layer == null:
				_entities_layer = c

func _ready():
	if _size.x <= 0 or _size.y <= 0:
		push_warning("The map's size is not positive - changing it to (8, 6)")
		_size = Vector2i(8, 8)
