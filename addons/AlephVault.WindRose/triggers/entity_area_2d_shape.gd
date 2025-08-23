extends CollisionShape2D

# The computed shape.
var _computed_shape: Shape2D = null

# The computed shape offset.
var _computed_offset: Vector2i = Vector2i(-1, -1)

# Makes a shape out of the map's layout and cell size,
# and the entity's cell size.
static func _compute_shape_contents(
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

# In the current shape, updates its contents.
func update_shape_contents(
	layout_type: AlephVault__WindRose.Maps.Utils.MapLayoutType,
	entity_size: Vector2i, cell_size: Vector2i
):
	var result: Array = _compute_shape_contents(
		layout_type, entity_size, cell_size
	)
	_computed_shape = result[0]
	_computed_offset = result[1]

func _process(delta):
	if _computed_shape != null:
		shape = _computed_shape
		position = _computed_offset
