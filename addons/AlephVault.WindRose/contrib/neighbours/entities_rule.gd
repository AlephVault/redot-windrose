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

# The callback to initialize the _up_linked
# property.
var _up_linked_callback

# The callback to initialize the _down_linked
# property.
var _down_linked_callback

# The callback to initialize the _left_linked
# property.
var _left_linked_callback

# The callback to initialize the _right_linked
# property.
var _right_linked_callback

# The up-linked entities rule.
var _up_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The up-linked entities rule. It is optional but,
## if set, it must match the width of this entities
## rule.
var up_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		if _up_linked == null and _up_linked_callback != null:
			_up_linked = _up_linked_callback.call()
			_up_linked_callback = null
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
var _down_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The down-linked entities rule. It is optional but,
## if set, it must match the width of this entities
## rule.
var down_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		if _down_linked == null and _down_linked_callback != null:
			_down_linked = _down_linked_callback.call()
			_down_linked_callback = null
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
var _left_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The left-linked entities rule. It is optional but,
## if set, it must match the height of this entities
## rule.
var left_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		if _left_linked == null and _left_linked_callback != null:
			_left_linked = _left_linked_callback.call()
			_left_linked_callback = null
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
var _right_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

## The right-linked entities rule. It is optional but,
## if set, it must match the height of this entities
## rule.
var right_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		if _right_linked == null and _right_linked_callback != null:
			_right_linked = _right_linked_callback.call()
			_right_linked_callback = null
		return _right_linked
	set(value):
		if (value != null and value.size.y != size.y):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"right_linked_mismatch",
				"The chosen right-linked rule has mismatching height"
			)
		else:
			_right_linked = value

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the neighbours rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Neighbours.EntityRule

## Construction takes the layer and the linked entities
## layers as well.
func _init(
	layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer,
	_up_linked: Callable,
	_down_linked: Callable,
	_left_linked: Callable,
	_right_linked: Callable
):
	super._init(layer.map.size)
	_entities_layer = layer
	_up_linked_callback = _up_linked
	_down_linked_callback = _down_linked
	_left_linked_callback = _left_linked
	_right_linked_callback = _right_linked

func on_movement_finished(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementConfirmedStage
) -> void:
	match stage:
		MovementConfirmedStage.End:
			match direction:
				_Direction.LEFT:
					if end_position.x == 0:
						if is_instance_valid(left_linked):
							entity_rule.map_entity.detach()
							entity_rule.map_entity.attach(
								left_linked.entities_layer.map,
								Vector2i(
									left_linked.entities_layer.map.size.x - entity_rule.size.x,
									end_position.y
								)
							)
				_Direction.UP:
					if end_position.y == 0:
						if is_instance_valid(up_linked):
							entity_rule.map_entity.detach()
							entity_rule.map_entity.attach(
								up_linked.entities_layer.map,
								Vector2i(
									end_position.x,
									up_linked.entities_layer.map.size.y - entity_rule.size.y,
								)
							)
				_Direction.RIGHT:
					if end_position.x == size.x - entity_rule.size.x:
						if is_instance_valid(right_linked):
							entity_rule.map_entity.detach()
							entity_rule.map_entity.attach(
								right_linked.entities_layer.map,
								Vector2i(0, end_position.y)
							)
				_Direction.DOWN:
					if end_position.y == size.y - entity_rule.size.y:
						if is_instance_valid(down_linked):
							entity_rule.map_entity.detach()
							entity_rule.map_entity.attach(
								down_linked.entities_layer.map,
								Vector2i(end_position.x, 0)
							)
