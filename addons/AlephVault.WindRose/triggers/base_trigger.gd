extends Area2D
## Triggers are a way to detect, in a WindRose-compatible way,
## the movement inside an area. This is intended so when the
## objects enter a trigger they may be affected in different
## ways (according to trigger's logic) and at different times.
##
## In order to use a trigger, the developer must first derive
## a subclass and implement the callbacks they want or perhaps
## using one of the provided signals (both mechanisms are given
## by this class as alternatives, being the signals the first
## things that trigger, and then the callbacks, if any).
##
## The events that matter are:
##
## 1. Entity entered: An entity started being detected by this
##    trigger, and the entity belongs to the same map.
## 2. Entity staying: An entity is still being detected by this
##    trigger, and the entity belongs to the same map.
## 3. Entity moved: An entity that is staying just moved to
##    another position in this map, while still being detected
##    by this area.
## 4. Entity left: An entity that was being detected by this
##    trigger is no more detected. This is because it left the
##    area of the trigger, the entire scene tree (e.g. being
##    destroyed) or being detached from the map.

# #############################################
# #############################################
# ######## Event Callbacks and Signals ########
# #############################################
# #############################################

## A signal telling when an entity just entered this map and
## this trigger. This signal is emitted before invoking the
## _entity_entered(entity) method in this class.
signal entity_entered(entity: AlephVault__WindRose.Maps.MapEntity)

## A signal telling when an entity is staying in this map and
## this trigger. This signal occurs in a _process(d) call, and
## occurs for all the entities in the trigger. This signal is
## emitted before invoking the _entity_staying(entity) method
## in this class.
##
## In terms of life-cycle, this event occurs repeatedly and
## between entity_entered(entity) and entity_left(entity).
signal entity_staying(entity: AlephVault__WindRose.Maps.MapEntity)

## A signal telling when an entity has just moved in this map
## and this trigger. This signal occurs as part of the signal
## named on_movement_finished signal in the entity. Also, it is
## emitted before invoking the _entity_moved(entity) method in
## this class.
##
## In terms of life-cycle, this event occurs repeatedly and
## between entity_entered(entity) and entity_left(entity).
signal entity_moved(entity: AlephVault__WindRose.Maps.MapEntity)

## A signal telling that an entity left this trigger and/or the
## map and/or the entire tree and/or was destroyed. This signal
## is emitted before invoking the _entity_exited(entity) method
## in this class.
signal entity_left(entity: AlephVault__WindRose.Maps.MapEntity)

## An optional callback to implement. To understand this event,
## see entity_entered(entity) documentation.
func _entity_entered(entity: AlephVault__WindRose.Maps.MapEntity):
	pass

## An optional callback to implement. To understand this event,
## see entity_staying(entity) documentation.
func _entity_staying(entity: AlephVault__WindRose.Maps.MapEntity):
	pass

## An optional callback to implement. To understand this event,
## see entity_moved(entity) documentation.
func _entity_moved(entity: AlephVault__WindRose.Maps.MapEntity):
	pass

## An optional callback to implement. To understand this event,
## see entity_left(entity) documentation.
func _entity_left(entity: AlephVault__WindRose.Maps.MapEntity):
	pass

# Triggers the entity_entered event.
func __trigger_entity_entered(entity):
	entity_entered.emit(entity)
	_entity_entered(entity)

# Triggers the entity_staying event.
func __trigger_entity_staying(entity):
	entity_staying.emit(entity)
	_entity_staying(entity)

# Triggers the entity_moved event.
func __trigger_entity_moved(entity):
	entity_moved.emit(entity)
	_entity_moved(entity)

# Triggers the entity_left event.
func __trigger_entity_left(entity):
	entity_left.emit(entity)
	_entity_left(entity)

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
	if _map_entity:
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

const _Shape = preload("./base_trigger_shape.gd")

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
	__start_registry()

func __teardown():
	"""
	This method is executed when this object stops
	being child of an entity that is attached to a
	map (i.e. ANY of those conditions is broken).
	"""

	if is_instance_valid(__shape):
		__shape.queue_free()
	__shape = null
	__stop_registry()

func _process(delta):
	"""
	Frame-processing involves checking the registry
	and ticking on the registry. Also, ensuring the
	shape is properly set up every time.
	"""
	
	if not __registry_running:
		return
	
	if not is_instance_valid(__shape):
		__shape = _Shape.new()
		__shape.update_shape_contents(
			_map_entity.current_map.layout.layout_type,
			_map_entity.size, _map_entity.current_map.layout.cell_size
		)
	var parent = __shape.get_parent()
	if parent != self:
		if parent != null:
			parent.remove_child(__shape)
		add_child(__shape)
	__tick_all()

func _area_entered(a: Area2D):
	__add_element(a)

func _body_entered(b: Node2D):
	__add_element(b)

func _area_exited(a: Area2D):
	__remove_element(a)

func _body_exited(b: Node2D):
	__remove_element(b)

# #############################################
# #############################################
# ########  Elements record invariant  ########
# #############################################
# #############################################

# This flag tells whether the registry is running.
# If false, it's not between __start_registry and
# __stop_registry.
var __registry_running: bool = false

# The elements in the registry.
var __registry_elements: Dictionary = {}

# This is a references count for the entities that
# the registered elements are tracked for. Perhaps
# two or more Node2D (body) objects / Area2D (area)
# objects are attached to the same entity. In this
# case, we don't want to track some events for the
# same entity twice.
var __registry_entities: Dictionary = {}

# This record tracks the data associated to an element,
# which is a body or area node overlapping with this
# Area2D object. It refers the associated entity and
# also has a callback to self-remove itself from this
# registry when it's removed from the tree or somehow
# unscoped from this trigger.
class ElementRecord:
	# The current entity for this object.
	var entity: AlephVault__WindRose.Maps.MapEntity
	
	# The exited_tree associated with the element
	# in the registry. When invoked, the element
	# will be un-registered.
	var exited_tree: Callable

# This record tracks the data associated to an entity.
# This means: an element exists in this registry but
# also one or more elements are associated with some
# entities, which can match (i.e. many elements to be
# children of the same entity). For this reason, now
# we track the entity with references count so we
# don't process the entity twice. It has its own new
# callback for on_movement_finished signal.
class EntityRecord:
	# The references count for this object.
	var references_count: int
	
	# The on_movement_finished signal callback.
	var on_movement_finished: Callable

func __start_registry():
	var areas: Array = get_overlapping_areas()
	for area in areas:
		__add_element(area)
	var bodies: Array = get_overlapping_bodies()
	for body in bodies:
		__add_element(body)
	__registry_running = true

func __stop_registry():
	__registry_running = false
	for e in __registry_elements.keys():
		__remove_element(e)

func __tick_all():
	for e in __registry_entities.keys():
		__tick(e)

func __tick(e: AlephVault__WindRose.Maps.MapEntity):
	if is_instance_valid(e):
		__trigger_entity_staying(e)

func __add_element(e: Node2D):
	if not __registry_elements.has(e):
		# First, create the record for this
		# element being added.
		var value = ElementRecord.new()
		__registry_elements[e] = value

		# Then, create a callback for this
		# element when it's taken from the
		# tree. Connect it to the signal of
		# the element being the key.
		var element_exited_tree = func():
			__remove_element(e)
		value.exited_tree = element_exited_tree
		e.tree_exited.connect(value)
		
		# Now, in the lapse of this record
		# existing, the object cannot change
		# their parent entity: it either has
		# or does not have an entity. So we
		# perform the tracking of the entity
		# (being attached, detached, moved
		# and staying) right here.
		var parent = e.get_parent()
		if parent is AlephVault__WindRose.Maps.MapEntity and parent.current_map == _map_entity.current_map:
			value.entity = parent
			__track_entity(parent)

func __remove_element(e: Node2D):
	if not __registry_elements.has(e):
		return
	var existing: ElementRecord = __registry_elements[e]
	if is_instance_valid(e) and e.tree_exited.is_connected(existing.exited_tree):
		e.tree_exited.disconnect(existing.exited_tree)
	__registry_elements.erase(e)
	if existing.entity != null:
		__untrack_entity(existing.entity)

func __track_entity(entity: AlephVault__WindRose.Maps.MapEntity):
	if not __registry_entities.has(entity):
		var value: EntityRecord = EntityRecord.new()
		__registry_entities[entity] = value
		__trigger_entity_entered(entity)
		# We don't need callbacks for on_detached
		# or on_attached in the object, since they
		# trigger tree-exits / tree-enters each
		# time. So they're already handled here.
		#
		# BUT we DO track the on_movement_finished
		# signal.
		var _on_movement_finished = func(
			fp: Vector2i, tp: Vector2i, d: AlephVault__WindRose.Utils.DirectionUtils.Direction
		):
			__trigger_entity_moved(entity)
		entity.rule.signals.on_movement_finished.connect(_on_movement_finished)
		value.on_movement_finished = _on_movement_finished
		
	var existing: EntityRecord = __registry_entities[entity]
	existing.references_count += 1

func __untrack_entity(entity: AlephVault__WindRose.Maps.MapEntity):
	if not __registry_entities.has(entity):
		return
	var existing: EntityRecord = __registry_entities[entity]
	existing.references_count -= 1
	if existing.references_count <= 0:
		# Here, we just clear the entity.
		__trigger_entity_left(entity)
		__registry_entities.erase(entity)
		if entity.rule.signals.on_movement_finished.is_connected(
			existing.on_movement_finished
		):
			entity.rule.signals.on_movement_finished.disconnect(
				existing.on_movement_finished
			)
