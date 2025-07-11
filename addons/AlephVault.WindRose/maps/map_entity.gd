extends Node2D

const _Map = AlephVault__WindRose.Maps.Map
const _EntityRule = AlephVault__WindRose.Core.EntityRule
const _EntitiesManager = AlephVault__WindRose.Core.EntitiesManager
const _MapEM = AlephVault__WindRose.Maps.Layers.EntitiesLayer.Manager
const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response

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

## The associated entity rule. This one must be an
## EXTERNAL resource, defined in a resource file
## (it cannot be an embedded resource), which is
## necessarily of a derived class.
##
## In the end, the actual entity rule will be
## instantiated out of it. 
@export var _rule_spec: AlephVault__WindRose.Resources.EntityRuleSpec

var _rule: _EntityRule

## The instantiated rule, out of the configured
## rule spec.
var rule: _EntityRule:
	get:
		if is_instance_valid(_rule):
			return _rule

		assert(
			_rule_spec != null,
			"The rule_spec is not set"
		)
		_rule = _rule_spec.create_rule(self)
		assert(
			is_instance_valid(_rule),
			"The rule is null"
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

var _current_map: _Map

## The current map.
var current_map: _Map:
	get:
		return _current_map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "current_map"
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
		return entity.cell + entity.size - Vector2i.ONE
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntity", "cellf"
		)

## The current orientation.
@export var orientation: _Direction = _Direction.DOWN:
	get:
		return orientation
	set(value):
		if value == _Direction.NONE:
			value = _Direction.DOWN
		orientation = value
		orientation_changed.emit(value)

## A signal to tell the change of orientation.
signal orientation_changed(orientation: _Direction)

## The current speed.
@export var speed: float:
	get:
		return speed
	set(value):
		speed = max(0, value)
		speed_changed.emit(speed)

## A signal to tell the change of speed.
signal speed_changed(speed: float)

## A state: IDLE.
const STATE_IDLE: int = 0

## The current state.
var state: int = STATE_IDLE:
	get:
		return state
	set(value):
		state = value
		state_changed.emit(state)

## A signal to tell the change of state.
signal state_changed(state: int)

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
	position = get_parent().layout.get_point(entity.cell)

func _on_attached(manager: _EntitiesManager, cell: Vector2i):
	if manager is _MapEM:
		# The manager is already assigned to the entity.
		# So we must, now, re-parent the object properly.
		if self.get_parent() != null:
			self.reparent(manager.layer)
		else:
			manager.layer.add_child(self)
		# Then, adjust the position.
		position = manager.layer.map.layout.get_point(cell)
		rotation = 0
		_origin = position
		_snap()
		_current_map = manager.layer.map

func _on_teleported(from_position: Vector2i, to_position: Vector2i):
	_snap()

func _on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	pass

func _on_movement_cancelled(
	from_position: Vector2i, reverted_position: Vector2i, direction: _Direction
):
	_snap()

func _on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	pass

func _on_detached():
	if _destroyed:
		return
	var _parent = self.get_parent()
	if _parent != null:
		_parent.remove_child(self)
	var _gparent = _parent.get_parent()
	if _gparent is AlephVault__WindRose.Maps.Scope:
		_gparent.add_child(self)

func _set_signals():
	var signals = entity.entity_rule.signals
	if signals:
		signals.on_attached.connect(_on_attached)
		signals.on_teleported.connect(_on_teleported)
		signals.on_movement_started.connect(_on_movement_started)
		signals.on_movement_cancelled.connect(_on_movement_cancelled)
		signals.on_movement_finished.connect(_on_movement_finished)
		signals.on_detached.connect(_on_detached)

func _unset_signals():
	var signals = entity.entity_rule.signals
	if signals:
		signals.on_attached.disconnect(_on_attached)
		signals.on_teleported.disconnect(_on_teleported)
		signals.on_movement_started.disconnect(_on_movement_started)
		signals.on_movement_cancelled.disconnect(_on_movement_cancelled)
		signals.on_movement_finished.disconnect(_on_movement_finished)
		signals.on_detached.disconnect(_on_detached)

func _init():
	_entity = Entity.new(self, rule)
	_set_signals()
	# Fixing editor-set properties and triggering
	# signals for the first time.
	orientation = orientation
	speed = speed
	state = state

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_destroyed = true
		_unset_signals()

## Initializes this object.
func initialize():
	if Engine.is_editor_hint():
		return
	
	if _initialized:
		return

	entity.initialize()
	
	var _parent = get_parent()
	var _parent2 = null
	if _parent != null:
		_parent2 = _parent.get_parent()
	if _parent2 is AlephVault__WindRose.Maps.Map and \
	   _parent2.layout != null and \
	   _parent is AlephVault__WindRose.Maps.Layers.EntitiesLayer:
		if not _parent.initialized:
			return
		var cell = _parent2.layout.local_to_map(position)
		var result = _parent.manager.attach(
			entity, cell
		)
		if result.is_successful():
			_initialized = true

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
func teleport(to_position: Vector2i) -> _Response:
	if _current_map == null:
		return _Response.succeed(false)
	return _current_map.entities_layer.manager.teleport(entity, to_position)

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

func _process(delta: float):
	updated.emit()
