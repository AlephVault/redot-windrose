extends Area2D

# The current map entity this trigger relates to.
var _map_entity: AlephVault__WindRose.Maps.MapEntity

# The shape to use.
var _shape: CollisionShape2D = null

# The offset to use for the shape.
var _shape_offset: Vector2i = Vector2i(-1, -1)

# The child to use for the area detection.
var _child: CollisionShape2D

## A signal telling an entity entered this area.
signal entity_entered(entity: AlephVault__WindRose.Maps.MapEntity)

## A signal telling an entity exited this area.
signal entity_exited(entity: AlephVault__WindRose.Maps.MapEntity)

func _make_area_shape(
	layout_type: AlephVault__WindRose.Maps.Utils.MapLayoutType,
	entity_size: Vector2i, cell_size: Vector2i
) -> Array:
	"""
	Makes a shape's content and the offset for that shape.
	"""

	var shape: Shape2D
	var x_: Vector2i
	var y_: Vector2i
	var offset: Vector2i = Vector2i(-1, -1)

	match layout_type:
		AlephVault__WindRose.Maps.Utils.MapLayoutType.ORTHOGONAL:
			shape = RectangleShape2D.new()
			shape.size = entity_size * cell_size
			offset = shape.size / 2.
			shape.size -= Vector2(2, 2)
		AlephVault__WindRose.Maps.Utils.MapLayoutType.ISOMETRIC_TOPDOWN:
			shape = ConvexPolygonShape2D.new()
			x_ = Vector2i(entity_size.x * cell_size.x, entity_size.x * cell_size.y) / 2
			y_ = Vector2i(-entity_size.y * cell_size.x, entity_size.y * cell_size.y) / 2
			shape.points = PackedVector2Array([
				Vector2i(0, 1),
				x_ + Vector2i(-1, 0),
				x_ + y_ + Vector2i(0, -1),
				y_ + Vector2i(1, 0)
			])
			offset = Vector2i(0, 0)
		AlephVault__WindRose.Maps.Utils.MapLayoutType.ISOMETRIC_LEFTRIGHT:
			shape = ConvexPolygonShape2D.new()
			x_ = Vector2i(entity_size.x * cell_size.x, -entity_size.x * cell_size.y) / 2
			y_ = Vector2i(entity_size.y * cell_size.x, entity_size.y * cell_size.y) / 2
			shape.points = PackedVector2Array([
				Vector2i(1, 0),
				x_ + Vector2i(0, 1),
				x_ + y_ + Vector2i(-1, 0),
				y_ + Vector2i(0, -1)
			])
			offset = Vector2i(0, 0)

	return [shape, offset]

func _set_area_shape():
	"""
	Sets the shape for the current collider based
	on the current map's layout and entity size.
	"""

	if _map_entity == null:
		return

	var map: AlephVault__WindRose.Maps.Map = _map_entity.current_map
	if map == null:
		return
	
	var cell_size: Vector2i = map.layout.cell_size
	var size: Vector2i = _map_entity.size
	var layout_type: AlephVault__WindRose.Maps.Utils.MapLayoutType = map.layout.layout_type
	var r: Array = _make_area_shape(
		layout_type, size, cell_size
	)
	_shape = r[0]
	_shape_offset = r[1]
	if _shape != null:
		var child = CollisionShape2D.new()
		child.shape = _shape
		child.position = _shape_offset
		_child = child
		add_child(child)
	elif _child != null:
		_child.queue_free()
		_child = null

func _on_attached(em, pos):
	_set_area_shape()

func _clear_area_shape():
	"""
	Clears the area shape for the current collider.
	"""

	_shape = null
	_shape_offset = Vector2i(-1, -1)
	if _child != null:
		_child.queue_free()
		_child = null

func _set_signals():
	if not _map_entity.rule.signals.on_attached.is_connected(_on_attached):
		_map_entity.rule.signals.on_attached.connect(_on_attached)
	if not _map_entity.rule.signals.on_detached.is_connected(_clear_area_shape):
		_map_entity.rule.signals.on_detached.connect(_clear_area_shape)
	if _map_entity.current_map != null:
		_set_area_shape()

func _clear_signals():
	if _map_entity != null:
		_clear_area_shape()
		if _map_entity.rule.signals.on_attached.is_connected(_on_attached):
			_map_entity.rule.signals.on_attached.disconnect(_on_attached)
		if _map_entity.rule.signals.on_detached.is_connected(_clear_area_shape):
			_map_entity.rule.signals.on_detached.disconnect(_clear_area_shape)

# On _enter_tree, track the entity.
func _enter_tree():
	var _parent = get_parent()
	if _parent is AlephVault__WindRose.Maps.MapEntity:
		_map_entity = _parent
		_set_signals()

# On _exit_tree, untrack the entity.
func _exit_tree() -> void:
	_clear_signals()
	_map_entity = null

func _process(delta):
	if _child != null:
		_child.position = _shape_offset
