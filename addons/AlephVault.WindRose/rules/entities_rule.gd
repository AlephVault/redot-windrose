extends Object
## An EntitiesRule has the responsibility
## to manage the entities: track data of
## the entities positions, tell whether
## a movement can be installed or cancelled,
## and tell whether an object can be attached
## to the related map.

## Stage of the movement-start operation.
## Used to tell on_movement_started which
## stage of the movement initiation is
## taking place.
enum MovementStartedStage {
	Begin, MovementAllocated, End
}

## Stage of the movement-cancel operation.
## Used to tell on_movement_cancelled which
## stage of the movement cancellation is
## taking place.
enum MovementClearedStage {
	Begin, MovementCleared, End
}

## Stage of the movement-confirm operation.
## Used to tell on_movement_finished which
## stage of the movement finish is taking
## place.
enum MovementConfirmedStage {
	Begin, PositionChanged, MovementCleared, End
}

## Stage of the teleport operation. Used
## to tell on_teleported which stage of
## the teleport is taking place. 
enum TeleportedStage {
	Begin, PositionChanged, End
}

var _entities_layer

## Returns the associated entity layer.
var entities_layer:
	get:
		return _entities_layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "entities_layer"
		)

var _size: Vector2i

## Returns the size for this rule.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "size"
		)

## Construction takes the entity layer and
## keeps that layer and size.
func _init(entities_layer) -> void:
	_entities_layer = entities_layer
	_size = entities_layer.size

var _initialized: bool = false

## Initializes the whole map rule.
func initialize() -> void:
	if self._initialized:
		return
	self._initialized = true

	# Initializes the internal data when it's ready.
	# This already comes from a TileMap, most likely.
	self.initialize_global_data()
	var s: Vector2i = self._size
	for y in range(s.y):
		for x in range(s.x):
			self.initialize_cell_data(Vector2i(x, y))

## Initializes global data for this rule.
## Make use of `size` property to understand
## the size of the underlying data.
func initialize_global_data() -> void:
	pass

## Initializes a cell's data for this rule.
func initialize_cell_data(cell: Vector2i) -> void:
	pass

## Updates a cell's data for this rule. Most
## likely, the same as initialize_cell_data.
func update_cell_data(cell: Vector2i) -> void:
	pass

## Tells whether an entity can be attached
## to the map.
func can_attach(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	cell: Vector2i
) -> bool:
	return true

## Handles when an entity has been attached to the map.
func on_entity_attached(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	to_position: Vector2i
) -> void:
	pass

## Tells whether an entity can start moving.
func can_move(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	direction: int
) -> bool:
	return true

## Handles when an entity started moving (to a single
## adjacent cell).
func on_movement_started(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: int,
	stage: MovementStartedStage
) -> void:
	pass

## Handles when an entity completed a movement (to a
## single adjacent cell).
func on_movement_finished(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: int,
	stage: MovementConfirmedStage
) -> void:
	pass

## Tells whether an entity can cancel its current movement.
func can_cancel_movement(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	direction: int
) -> bool:
	return true

## Handles when an entity cancelled a movement.
func on_movement_cancelled(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	start_position: Vector2i, reverted_position: Vector2i, direction: int,
	stage: MovementClearedStage
) -> void:
	pass

## Handles when an entity was teleported to a new position
## in the map.
func on_teleported(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	from_position: Vector2i, to_position: Vector2i,
	stage: TeleportedStage
) -> void:
	pass

## Handles when an entity was detached from the map.
func on_entity_detached(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	from_position: Vector2i
) -> void:
	pass

## Handles when an entity has one of the properties changed
## on one of the entity-side rules.
func on_property_updated(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	property: String, old_value, new_value
) -> void:
	pass
