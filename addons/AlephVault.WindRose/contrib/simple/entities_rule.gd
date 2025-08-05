extends AlephVault__WindRose.Core.EntitiesRule
## This entities rule combines the power of the
## blocking, solidness, navigability and neighbours
## entities rules. The logic to allow a movement
## requires approval from all the 4 behaviours, and
## the callbacks of this rule are forwarded to the
## 4 behaviours as well.
##
## To get more information on the related behaviorus,
## see these classes:
##
## - AlephVault__WindRose.Contrib.Solidness.EntitiesRule
## - AlephVault__WindRose.Contrib.Blocking.EntitiesRule
## - AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
## - AlephVault__WindRose.Contrib.Navigability.EntitiesRule

# The underlying blocking entities rule.
var _blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntitiesRule

# The underlying solidness entities rule.
var _solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntitiesRule

# The underlying neighbours entities rule.
var _neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

# The underlying navigability entities rule.
var _navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntitiesRule

## The underlying blocking entities rule.
var blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntitiesRule:
	get:
		return _blocking_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "blocking_rule"
		)

## The underlying solidness entities rule.
var solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntitiesRule:
	get:
		return _solidness_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "solidness_rule"
		)

## The underlying neighbours entities rule.
var neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _neighbours_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "neighbours_rule"
		)

## The underlying navigability entities rule.
var navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntitiesRule:
	get:
		return _navigability_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "navigability_rule"
		)

func initialize_global_data():
	blocking_rule.initialize_global_data()
	solidness_rule.initialize_global_data()
	navigability_rule.initialize_global_data()

func initialize_cell_data(cell: Vector2i) -> void:
	blocking_rule.initialize_cell_data(cell)
	navigability_rule.initialize_cell_data(cell)
	
func update_cell_data(cell: Vector2i) -> void:
	blocking_rule.update_cell_data(cell)
	navigability_rule.update_cell_data(cell)

func can_move(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	position: Vector2i, direction: _Direction
) -> bool:
	return (
		blocking_rule.can_move(
			entity_rule.blocking_rule,
			position, direction
		) and
		solidness_rule.can_move(
			entity_rule.solidness_rule,
			position, direction
		) and
		navigability_rule.can_move(
			entity_rule.navigability_rule,
			position, direction
		)
	)

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the simple rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Simple.EntityRule

func _init(
	layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer,
	_up_linked: Callable,
	_down_linked: Callable,
	_left_linked: Callable,
	_right_linked: Callable
):
	_blocking_rule = AlephVault__WindRose.Contrib.Blocking.EntitiesRule.new(
		layer
	)
	_solidness_rule = AlephVault__WindRose.Contrib.Solidness.EntitiesRule.new(
		layer.map.size
	)
	_neighbours_rule = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule.new(
		layer, _up_linked, _down_linked, _left_linked, _right_linked
	)
	_navigability_rule = AlephVault__WindRose.Contrib.Navigability.EntitiesRule.new(
		layer
	)

func on_entity_attached(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	to_position: Vector2i
) -> void:
	solidness_rule.on_entity_attached(
		entity_rule.solidness_rule,
		to_position
	)

func on_movement_started(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementStartedStage
) -> void:
	solidness_rule.on_movement_started(
		entity_rule.solidness_rule,
		start_position, end_position, direction, stage
	)

func on_movement_finished(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementConfirmedStage
) -> void:
	solidness_rule.on_movement_finished(
		entity_rule.solidness_rule,
		start_position, end_position, direction, stage
	)
	neighbours_rule.on_movement_finished(
		entity_rule.neighbours_rule,
		start_position, end_position, direction, stage
	)

func on_movement_cancelled(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, reverted_position: Vector2i, direction: _Direction,
	stage: MovementClearedStage
) -> void:
	solidness_rule.on_movement_cancelled(
		entity_rule.solidness_rule,
		start_position, reverted_position, direction, stage
	)

func on_teleported(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	from_position: Vector2i, to_position: Vector2i,
	stage: TeleportedStage
) -> void:
	solidness_rule.on_teleported(
		entity_rule.solidness_rule,
		from_position, to_position, stage
	)

func on_property_updated(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	property: String, old_value, new_value
) -> void:
	solidness_rule.on_property_updated(
		entity_rule.solidness_rule,
		property, old_value, new_value
	)

func on_entity_detached(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	from_position: Vector2i
) -> void:
	solidness_rule.on_entity_detached(
		entity_rule.solidness_rule,
		from_position
	)
