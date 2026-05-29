extends Node2D
## This is a map entity layer.
##
## Override this class' _create_rule to return a custom
## instance of AlephVault__WindRose.Core.EntityRule.
## This will be assigned internally to the `rule` field,
## perhaps initialized from custom properties you define.

const _Map = AlephVault__WindRose.Maps.Map
const _MapEntityData = AlephVault__WindRose.Maps.MapEntityData
const _EntityRule = AlephVault__WindRose.Core.EntityRule
const _EntitiesManager = AlephVault__WindRose.Core.EntitiesManager
const _MapEM = AlephVault__WindRose.Maps.Layers.EntitiesLayer.Manager
const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response

var _visuals_container: AlephVault__WindRose.Maps.Layers.VisualsLayer.VisualsContainer
var _visuals_container_tree_exited: Callable

## An entities manager aware of this layer.
class Entity extends AlephVault__WindRose.Core.Entity:
	
	var _map_entity
	
	## The map entity this manager is bound to.
	var map_entity:
		get:
			return _map_entity
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"MapEntity.Entity", "map_entity"
			)

	func _init(map_entity, entity_rule: _EntityRule):
		super._init(entity_rule)
		_map_entity = map_entity

var _rule: _EntityRule

func _create_rule() -> _EntityRule:
	"""
	Creates an entity rule.
	"""
	
	return null

## The instantiated rule, out of the configured
## rule spec.
var rule: _EntityRule:
	get:
		if is_instance_valid(_rule):
			return _rule

		_rule = _create_rule()
		assert(
			is_instance_valid(_rule),
			"Implement entity_layer's _create_rule() to return a non-null " + 
			"AlephVault__Windrose.Core.EntityRule instance"
		)
		return _rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "rule"
		)

var _entity: Entity

## The underlying logical entity for
## this map entity.
var entity: Entity:
	get:
		return _entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "entity"
		)

var _paused: bool

## Whether this entity is paused or not.
var paused: bool:
	get:
		return _paused
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "paused"
		)

var _current_map: _Map

## The current map.
var current_map: _Map:
	get:
		return _current_map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "current_map"
		)

## The map entity size, expressed as (width, height).
@export_category("Topology")
@export var _size: Vector2i = Vector2i(1, 1)

## Gets the map entity size.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "size"
		)

## The current cell.
var cell: Vector2i:
	get:
		return entity.cell
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "cell"
		)

## The current opposite cell.
var cellf: Vector2i:
	get:
		return entity.cell + size - Vector2i.ONE
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "cellf"
		)

## The initial position. Set it to values
## greater than 0 in both components to
## make it sure the entity is properly
## placed on static initialization.
@export var _initial_position: Vector2i = Vector2i(-1, -1)

var initial_position: Vector2i:
	get:
		return _initial_position
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "initial_position"
		)
## The current orientation.
@export var orientation: _Direction = _Direction.DOWN:
	get:
		return orientation
	set(value):
		if value == _Direction.NONE:
			value = _Direction.DOWN
		orientation = value
		_set_digest_orientation(value)
		on_orientation_changed.emit(value)

## A signal to tell the change of orientation.
signal on_orientation_changed(orientation: _Direction)

## The current speed.
@export var speed: float = 0.0625:
	get:
		return speed
	set(value):
		speed = clampf(value, MIN_SPEED, MAX_SPEED)
		_set_digest_speed(speed)
		on_speed_changed.emit(speed)

## A signal to tell the change of speed.
signal on_speed_changed(speed: float)

## A state: IDLE.
const STATE_IDLE: int = 0

## A state: MOVING.
const STATE_MOVING: int = 1

const MIN_SPEED: float = 0.0625
const MAX_SPEED: float = 4095.9375

const _DIGEST_PRESENCE_NOT_IN_MAP: int = 0
const _DIGEST_PRESENCE_NOT_MOVING: int = 1
const _DIGEST_PRESENCE_MOVING: int = 4

const _DIGEST_ORIENTATION_SHIFT: int = 51
const _DIGEST_PRESENCE_SHIFT: int = 48
const _DIGEST_SPEED_SHIFT: int = 32
const _DIGEST_CELL_X_SHIFT: int = 20
const _DIGEST_CELL_Y_SHIFT: int = 8

const _DIGEST_ORIENTATION_MASK: int = 0x3
const _DIGEST_PRESENCE_MASK: int = 0x7
const _DIGEST_SPEED_MASK: int = 0xffff
const _DIGEST_CELL_MASK: int = 0xfff
const _DIGEST_STATE_MASK: int = 0xff

var _digest_orientation: int = 1
var _digest_presence: int = _DIGEST_PRESENCE_NOT_IN_MAP
var _digest_speed: int = 1
var _digest_cell: Vector2i = Vector2i.ZERO
var _digest_state: int = STATE_IDLE
var _digest: int = (1 << _DIGEST_ORIENTATION_SHIFT) | (1 << _DIGEST_SPEED_SHIFT)

## Returns the packed entity snapshot:
## [11 reserved][2 orientation][3 presence][16 speed][12 x][12 y][8 state].
##
## The digest is updated by the public state, speed, orientation and
## map lifecycle APIs. Reserved bits are always emitted as 0.
func get_digest() -> int:
	return _digest

func _direction_to_digest_orientation(direction: _Direction) -> int:
	match direction:
		_Direction.UP:
			return 0
		_Direction.DOWN:
			return 1
		_Direction.LEFT:
			return 2
		_Direction.RIGHT:
			return 3
		_:
			return 1

func _digest_orientation_to_direction(value: int) -> _Direction:
	match value & _DIGEST_ORIENTATION_MASK:
		0:
			return _Direction.UP
		1:
			return _Direction.DOWN
		2:
			return _Direction.LEFT
		_:
			return _Direction.RIGHT

func _set_digest_orientation(value: _Direction) -> void:
	_digest_orientation = _direction_to_digest_orientation(value)
	_update_digest()

func _set_digest_presence(value: int) -> void:
	_digest_presence = value & _DIGEST_PRESENCE_MASK
	_update_digest()

func _set_digest_speed(value: float) -> void:
	_digest_speed = int(value * 16) & _DIGEST_SPEED_MASK
	_update_digest()

func _set_digest_cell(value: Vector2i) -> void:
	_digest_cell = Vector2i(
		clampi(value.x, 0, _DIGEST_CELL_MASK),
		clampi(value.y, 0, _DIGEST_CELL_MASK)
	)
	_update_digest()

func _set_digest_state(value: int) -> void:
	_digest_state = clampi(value, 0, _DIGEST_STATE_MASK)
	_update_digest()

func _update_digest() -> void:
	_digest = \
		((_digest_orientation & _DIGEST_ORIENTATION_MASK) << _DIGEST_ORIENTATION_SHIFT) | \
		((_digest_presence & _DIGEST_PRESENCE_MASK) << _DIGEST_PRESENCE_SHIFT) | \
		((_digest_speed & _DIGEST_SPEED_MASK) << _DIGEST_SPEED_SHIFT) | \
		((_digest_cell.x & _DIGEST_CELL_MASK) << _DIGEST_CELL_X_SHIFT) | \
		((_digest_cell.y & _DIGEST_CELL_MASK) << _DIGEST_CELL_Y_SHIFT) | \
		(_digest_state & _DIGEST_STATE_MASK)

## Applies a packed entity snapshot.
##
## This decodes and applies state, speed and orientation first. Then it
## applies presence and cell data:
## - 000 detaches from the current map and clears the digest cell.
## - 001 cancels movement or teleports to the decoded cell.
## - 1xx cancels movement or teleports, then starts movement in direction xx.
##
## Invalid presence values 010 and 011 are warned and normalized to 000 when
## outside a map or 001 when inside a map. If force is false, unchanged fields
## are skipped; if true, decoded state, speed, orientation and presence/cell
## effects are applied even when they match the current digest.
func set_digest(d: int, force: bool = false) -> void:
	var next_orientation_bits: int = (d >> _DIGEST_ORIENTATION_SHIFT) & _DIGEST_ORIENTATION_MASK
	var next_orientation: _Direction = _digest_orientation_to_direction(next_orientation_bits)
	var next_presence: int = (d >> _DIGEST_PRESENCE_SHIFT) & _DIGEST_PRESENCE_MASK
	var next_speed: float = float((d >> _DIGEST_SPEED_SHIFT) & _DIGEST_SPEED_MASK) / 16.0
	var next_cell: Vector2i = Vector2i(
		(d >> _DIGEST_CELL_X_SHIFT) & _DIGEST_CELL_MASK,
		(d >> _DIGEST_CELL_Y_SHIFT) & _DIGEST_CELL_MASK
	)
	var next_state: int = d & _DIGEST_STATE_MASK
	var previous_presence: int = _digest_presence
	var previous_cell: Vector2i = _digest_cell

	if force or state != next_state:
		state = next_state
	if force or speed != next_speed:
		speed = next_speed
	if force or orientation != next_orientation:
		orientation = next_orientation

	if next_presence == 2 or next_presence == 3:
		push_warning("Invalid digest presence. Normalizing it to the current map membership.")
		next_presence = _DIGEST_PRESENCE_NOT_MOVING if _current_map != null else _DIGEST_PRESENCE_NOT_IN_MAP

	if next_presence == _DIGEST_PRESENCE_NOT_IN_MAP:
		if force or previous_presence != _DIGEST_PRESENCE_NOT_IN_MAP:
			if _current_map != null:
				var detach_response: _Response = detach()
				if not detach_response.is_successful():
					push_warning("Digest detach failed.")
			else:
				_set_digest_presence(_DIGEST_PRESENCE_NOT_IN_MAP)
		_set_digest_cell(Vector2i.ZERO)
		return

	var should_apply_presence: bool = force or \
		previous_presence != next_presence or previous_cell != next_cell
	if not should_apply_presence:
		return

	if _current_map == null:
		push_warning("Digest presence requires a map, but this object is not in a map.")
		_set_digest_presence(_DIGEST_PRESENCE_NOT_IN_MAP)
		_set_digest_cell(Vector2i.ZERO)
		return

	if next_presence == _DIGEST_PRESENCE_NOT_MOVING:
		if previous_cell != next_cell:
			var teleport_response: _Response = teleport(next_cell)
			if not teleport_response.is_successful():
				push_warning("Digest teleport failed.")
				return
		else:
			var cancel_response: _Response = cancel_movement()
			if not cancel_response.is_successful():
				push_warning("Digest movement cancellation failed.")
		return

	if previous_cell != next_cell:
		var moving_teleport_response: _Response = teleport(next_cell)
		if not moving_teleport_response.is_successful():
			push_warning("Digest teleport failed.")
			return
	else:
		var moving_cancel_response: _Response = cancel_movement()
		if not moving_cancel_response.is_successful():
			push_warning("Digest movement cancellation failed.")

	var movement_direction: _Direction = _digest_orientation_to_direction(next_presence)
	var movement_response: _Response = start_movement(movement_direction)
	if not movement_response.is_successful():
		push_warning("Digest movement start failed.")

## Gets the digested visual data that characterizes the object, if any.
## Gets an empty array if no data provider belongs to this object. The
## provider is an AlephVault__WindRose.Maps.MapEntityData instance.
var data: PackedByteArray:
	get:
		var provider: _MapEntityData = _get_data_provider()
		if provider != null:
			return provider.data
		return PackedByteArray()
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "data"
		)

## This is the data provider related to this object. By default, it is null.
## Developers must override _get_data_provider() to return something here.
##
## Access this property to get the underlying data provider and perform their
## updates accordingly.
var data_provider: _MapEntityData:
	get:
	    return _get_data_provider()
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "data_provider"
		)

## This signal tells when the data is updated. The argument is some
## partial data being updated. The final data, by this point, was
## already updated.
signal data_updated(data: PackedByteArray)

## Updates the data. This method is forwarded to the underlying provider,
## if one exists.
func update_data(data: PackedByteArray, merge: bool = false) -> bool:
	var provider: _MapEntityData = _get_data_provider()
	if provider != null:
	    # update_data(., .) will trigger the data_updated signal.
		return provider.update_data(data, merge)
	return false

## Gets the internal data provider for this object. If it's null, then
## no data will be forwarded / obtained. This is defined in subclasses.
func _get_data_provider() -> _MapEntityData:
	return null

## Tells which state to set as stopped when
## the object stops moving or is just attached.
func _get_idle_state() -> int:
	return STATE_IDLE

## Tells which state to set as moving when
## the object starts moving.
func _get_moving_state() -> int:
	return STATE_MOVING

## The current state.
var state: int = STATE_IDLE:
	get:
		return state
	set(value):
		state = clampi(value, 0, _DIGEST_STATE_MASK)
		_set_digest_state(state)
		on_state_changed.emit(state)

## A signal to tell the change of state.
signal on_state_changed(state: int)

## A signal telling to update typically visual objects
## depending on this object. Connect a method to this
## signal to hook to a post-_process(...) hook of this
## object, after its position was updated.
signal updated()

# Whether it's initialized or not.
var _initialized: bool = false
var _destroyed: bool = false

# The current origin / target positions, in pixels.
var _origin: Vector2i = Vector2i.ZERO
var _target: Vector2i = Vector2i.ZERO

func _snap():
	if _destroyed or entity == null or entity.manager == null:
		return
	position = get_parent().map.layout.get_point(entity.cell)

func _on_attached(manager: _EntitiesManager, cell: Vector2i):
	if manager is _MapEM:
		# The manager is already assigned to the entity.
		# So we must, now, re-parent the object properly.
		_current_map = manager.layer.map
		state = _get_idle_state()
		_set_digest_cell(cell)
		_set_digest_presence(_DIGEST_PRESENCE_NOT_MOVING)
		if self.get_parent() != null:
			self.reparent(manager.layer)
		else:
			manager.layer.add_child(self)
			if manager.layer.paused:
				self.pause()
			else:
				self.resume()

		# Then, adjust the position.
		position = manager.layer.map.layout.get_point(cell)
		rotation = 0
		_origin = position
		_snap()
		# Also, if the map has the visuals layer, then
		# proceed to create and bind the visuals entity.
		if _current_map.visuals_layer != null:
			var vc = AlephVault__WindRose.Maps.Layers.VisualsLayer.VisualsContainer.new()
			_visuals_container = vc
			_visuals_container.bind_entity(self)
			_visuals_container_tree_exited = Callable(self, "_on_visuals_container_tree_exited").bind(vc)
			_visuals_container.tree_exited.connect(_visuals_container_tree_exited)

func _on_visuals_container_tree_exited(vc):
	call_deferred("_clear_visuals_container_if_detached", vc)

func _clear_visuals_container_if_detached(vc):
	if is_instance_valid(vc) and vc.is_inside_tree():
		return
	if is_instance_valid(vc) and vc.tree_exited.is_connected(_visuals_container_tree_exited):
		vc.tree_exited.disconnect(_visuals_container_tree_exited)
	if vc == _visuals_container:
		_visuals_container = null
	_visuals_container_tree_exited = Callable()

func _on_teleported(from_position: Vector2i, to_position: Vector2i):
	_snap()
	state = _get_idle_state()
	_set_digest_cell(to_position)
	_set_digest_presence(_DIGEST_PRESENCE_NOT_MOVING)

func _on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	state = _get_moving_state()
	_set_digest_presence(
		_DIGEST_PRESENCE_MOVING | _direction_to_digest_orientation(direction)
	)

func _on_movement_canceled(
	from_position: Vector2i, reverted_position: Vector2i, direction: _Direction
):
	_snap()
	state = _get_idle_state()
	_set_digest_presence(_DIGEST_PRESENCE_NOT_MOVING)

func _on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	state = _get_idle_state()
	_set_digest_cell(to_position)
	_set_digest_presence(_DIGEST_PRESENCE_NOT_MOVING)

func _on_detached():
	state = _get_idle_state()
	_set_digest_cell(Vector2i.ZERO)
	_set_digest_presence(_DIGEST_PRESENCE_NOT_IN_MAP)
	if _destroyed:
		return
	var _parent = self.get_parent()
	if _parent != null:
		_parent.remove_child(self)
	var _gparent = _parent.get_parent()
	if _gparent is AlephVault__WindRose.Maps.Scope:
		_gparent.add_child(self)
	_current_map = null

func _set_signals():
	var signals = entity.entity_rule.signals
	if signals:
		signals.on_attached.connect(_on_attached)
		signals.on_teleported.connect(_on_teleported)
		signals.on_movement_started.connect(_on_movement_started)
		signals.on_movement_canceled.connect(_on_movement_canceled)
		signals.on_movement_finished.connect(_on_movement_finished)
		signals.on_detached.connect(_on_detached)

func _unset_signals():
	var signals = entity.entity_rule.signals
	if signals:
		signals.on_attached.disconnect(_on_attached)
		signals.on_teleported.disconnect(_on_teleported)
		signals.on_movement_started.disconnect(_on_movement_started)
		signals.on_movement_canceled.disconnect(_on_movement_canceled)
		signals.on_movement_finished.disconnect(_on_movement_finished)
		signals.on_detached.disconnect(_on_detached)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_destroyed = true
		_unset_signals()

## Initializes this object.
func initialize():
	if Engine.is_editor_hint() and not EditorInterface.is_playing_scene():
		return
	
	if _initialized:
		return

	_size = Vector2i(max(_size.x, 1), max(_size.y, 1))
	# Initialize the entity only once.
	_entity = Entity.new(self, rule)
	_set_signals()
	_initialized = true

	# Fixing editor-set properties and triggering
	# signals for the first time.
	orientation = orientation
	speed = speed
	state = state
	var _parent = get_parent()
	var _parent2 = null
	if _parent != null:
		_parent2 = _parent.get_parent()
	if _parent2 is AlephVault__WindRose.Maps.Map and \
	   _parent is AlephVault__WindRose.Maps.Layers.EntitiesLayer:
		if not _parent.initialized:
			return
		var cell = _parent2.layout.local_to_map(position) \
			if _initial_position.x < 0 or _initial_position.y < 0 else \
			_initial_position
		var result = _parent.manager.attach(
			entity, cell
		)

func _ready():
	initialize()

## Attaches this entity to a (new) map.
func attach(map: _Map, to_position: Vector2i) -> _Response:
	if _current_map == map:
		return _Response.succeed(false)
	elif _current_map != null:
		return _Response.fail(_Exception.raise(
			"already_attached", "This entity is already attached to a map"
		))
	return map.entities_layer.manager.attach(entity, to_position)

## Detaches an object from the current map.
func detach() -> _Response:
	if _current_map == null:
		return _Response.succeed(false)
	return _current_map.entities_layer.manager.detach(entity)

## Teleports the entity to a new position.
## It can be done silently, to not trigger public
## entity-side teleport events.
func teleport(to_position: Vector2i, silent: bool = false) -> _Response:
	if _current_map == null:
		return _Response.succeed(false)
	var result = _current_map.entities_layer.manager.teleport(entity, to_position, silent)
	if result.is_successful() and silent:
		# Only update the digest if the position that was updated was this one.
		# It might happen that an entities rule also caused a teleport on its
		# own (a separate teleport on its own) to a different position. THAT
		# causes another, separate, update on the cells.
		if to_position == cell:
			_set_digest_cell(to_position)
	return result

## Starts a movement to certain position.
func start_movement(direction: _Direction) -> _Response:
	if _current_map == null:
		return _Response.succeed(false)
	return _current_map.entities_layer.manager.movement_start(entity, direction)

## Cancels the current movement, if any.
func cancel_movement() -> _Response:
	if _current_map == null:
		return _Response.succeed(false)
	return _current_map.entities_layer.manager.movement_cancel(entity)

## Adds a MapEntityVisual to this entity.
func add_visual(v: AlephVault__WindRose.Maps.Visuals.MapEntityVisual):
	if v.get_parent() != null:
		AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
			"already_parented", "This MapEntityVisual has already a parent"
		)
		return

	if is_instance_valid(_visuals_container):
		_visuals_container.add_child(v)
		v.setup(self)
		v.visible = true
	else:
		add_child(v)
		v.visible = false
	if paused:
		v.pause()
	else:
		v.resume()

## Removes a MapEntityVisual from this entity.
func remove_visual(v: AlephVault__WindRose.Maps.Visuals.MapEntityVisual):
	if not is_instance_valid(v):
		return
	
	var parent: Node2D = null
	if is_instance_valid(_visuals_container):
		parent = _visuals_container
	else:
		parent = self
	
	if parent != v.get_parent():
		AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
			"parent_mismatch", "This MapEntityVisual does not have this entity as parent"
		)
		return

	if is_instance_valid(_visuals_container):
		v.teardown(self)
	parent.remove_child(v)
	v.visible = false

## Pauses an entity and its animations.
func pause():
	_paused = true
	if is_instance_valid(_visuals_container):
		_visuals_container.pause()

## Resumes an entity and its animations.
func resume():
	_paused = false
	if is_instance_valid(_visuals_container):
		_visuals_container.resume()

func _process(delta: float):
	updated.emit()
	if _visuals_container != null:
		_visuals_container.update(delta)
