extends Area2D
## A BaseArea stands for an area that adapts to the effective
## shape of a parent entity (depending on the current map's
## tile size, the layout type, and the entity size). Other
## than that, the behaviour is like a regular Area2D object,
## but its size / shape is automatically determined to fit
## the needs of any WindRose game.

# #############################################
# #############################################
# ######## Entity life-cycle invariant ########
# ######## Calls: __setup / __teardown ########
# #############################################
# #############################################

var _map_entity: AlephVault__WindRose.Maps.MapEntity

func _enter_tree() -> void:
	var parent = get_parent()
	if parent is AlephVault__WindRose.Maps.MapEntity:
		_map_entity = parent
		__entity_set(_map_entity)

func _exit_tree() -> void:
	if _map_entity != null:
		var e = _map_entity
		_map_entity = null
		__entity_cleared(e)

func __entity_set(e: AlephVault__WindRose.Maps.MapEntity):
	if not e.rule.signals.on_attached.is_connected(__entity_on_attached):
		e.rule.signals.on_attached.connect(__entity_on_attached)
	if not e.rule.signals.on_detached.is_connected(__entity_on_detached):
		e.rule.signals.on_detached.connect(__entity_on_detached)
	if e.current_map != null:
		__setup()
	
func __entity_cleared(e: AlephVault__WindRose.Maps.MapEntity):
	if e.rule.signals.on_attached.is_connected(__entity_on_attached):
		e.rule.signals.on_attached.disconnect(__entity_on_attached)
	if e.rule.signals.on_detached.is_connected(__entity_on_detached):
		e.rule.signals.on_detached.disconnect(__entity_on_detached)
	__teardown()

func __entity_on_attached(em, pos):
	__setup()

func __entity_on_detached():
	__teardown()

# #############################################
# #############################################
# ########   In-map entity invariant   ########
# #############################################
# #############################################

const _Shape = preload("./entity_area_2d_shape.gd")

var __shape: _Shape

func __setup_later():
	await get_tree().process_frame
	__setup()

func __setup():
	"""
	This method is executed when this object becomes
	child of an entity that is attached to a map (i.e.
	all the conditions become met by this point).
	"""

	# Under certain conditions, the .current_map of
	# the entity is not set (e.g. if the on_attached
	# callback is registered BEFORE the entity's one,
	# mainly because this object is earlier in the
	# tree before the entity has initialized in first
	# place) then let's delay this function to be
	# invoked later.
	if _map_entity.current_map == null:
		__setup_later()
		return

	if is_instance_valid(__shape):
		__shape.queue_free()
	__shape = _Shape.new()
	__shape.update_shape_contents(
		_map_entity.current_map.layout.layout_type,
		_map_entity.size, _map_entity.current_map.layout.cell_size
	)
	add_child(__shape)

func __teardown():
	"""
	This method is executed when this object stops
	being child of an entity that is attached to a
	map (i.e. ANY of those conditions is broken).
	"""

	if is_instance_valid(__shape):
		__shape.queue_free()
	__shape = null
