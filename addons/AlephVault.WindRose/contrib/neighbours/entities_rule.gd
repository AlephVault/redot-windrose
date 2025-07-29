extends AlephVault__WindRose.Core.EntitiesRule
## This is an implementation of an entities rule
## where the bondaries of the map can be linked
## to other maps, so that when an objects finished
## moving to that boundary, it gets teleported to
## the target map, and the opposite boundary.

# The owning entities layer. It will be referenced
# directly later, by teleport means.
var _entities_layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer

## The owning entities layer. It will be referenced
## directly later, by teleport means.
var entities_layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer:
	get:
		return _entities_layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "entities_layer"
		)

# The up-linked entities rule.
var _up_linked = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The up-linked entities rule. It is optional but,
## if set, it must match the width of this entities
## rule.
var up_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _up_linked
	set(value):
		if (value != null and value.size.x != size.x):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"up_linked_mismatch",
				"The chosen up-linked rule has mismatching width"
			)
		else:
			_up_linked = value

# The down-linked entities layer.
var _down_linked = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The down-linked entities rule. It is optional but,
## if set, it must match the width of this entities
## rule.
var down_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _down_linked
	set(value):
		if (value != null and value.size.x != size.x):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"down_linked_mismatch",
				"The chosen down-linked rule has mismatching width"
			)
		else:
			_down_linked = value

# The left-linked entities layer.
var _left_linked = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The left-linked entities rule. It is optional but,
## if set, it must match the height of this entities
## rule.
var left_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _left_linked
	set(value):
		if (value != null and value.size.y != size.y):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"left_linked_mismatch",
				"The chosen left-linked rule has mismatching height"
			)
		else:
			_left_linked = value

# The right-linked entities layer.
var _right_linked = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The right-linked entities rule. It is optional but,
## if set, it must match the height of this entities
## rule.
var right_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _right_linked
	set(value):
		if (value != null and value.size.y != size.y):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"right_linked_mismatch",
				"The chosen right-linked rule has mismatching height"
			)
		else:
			_right_linked = value

## Construction takes the size and the linked entities
## layers as well.
func _init(
	layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer,
	_up_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule,
	_down_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule,
	_left_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule,
	_right_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
):
	super._init(size)
	up_linked = _up_linked
	down_linked = _down_linked
	left_linked = _left_linked
	right_linked = _right_linked

func on_movement_finished(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementConfirmedStage
) -> void:
	if end_position.x == 0:
		if is_instance_valid(_left_linked):
			entity_rule.map_entity.detach()
			entity_rule.map_entity.attach(
				_left_linked.entities_layer.map,
				Vector2i(
					_left_linked.entities_layer.size.x - entity_rule.size.x,
					end_position.y
				)
			)
	elif end_position.y == 0:
		if is_instance_valid(_up_linked):
			entity_rule.map_entity.detach()
			entity_rule.map_entity.attach(
				_up_linked.entities_layer.map,
				Vector2i(
					end_position.x,
					_up_linked.entities_layer.size.y - entity_rule.size.y,
				)
			)
	elif end_position.x == size.x - entity_rule.size.x:
		if is_instance_valid(_right_linked):
			entity_rule.map_entity.detach()
			entity_rule.map_entity.attach(
				_right_linked.entities_layer.map,
				Vector2i(0, end_position.y)
			)
	elif end_position.y == size.y - entity_rule.size.y:
		if is_instance_valid(_down_linked):
			entity_rule.map_entity.detach()
			entity_rule.map_entity.attach(
				_down_linked.entities_layer.map,
				Vector2i(end_position.x, 0)
			)
