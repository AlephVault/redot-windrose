extends AlephVault__WindRose.Core.EntitiesRule
## This entities rule tracks the current solidness
## of each cell. The solidness is accumulated from
## all the objects standing on that cell (yes: many
## objects can occupy cells in common, provided they
## are allowed to do so by this and other rules). If
## the accumulated solidness is positive, objects
## obeying the solidness will be blocked in the
## direction of those objects. Otherwise, they will
## be allowed to move.
##
## An array of solidness is tracked, and each time an
## object is moved, cancelled, finished moving, added,
## removed or teleported, or has its solidness changed,
## this array is updated.

const _Solidness = AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness

# The solidness array.
var _solidness: Array[int]

## Initializes the global data, by allocating an array
## of integer values, each meaning a blocking status
## of each cell.
func initialize_global_data():
	_solidness = []
	_solidness.resize(size.x * size.y)

# Increments solidness by 1 in the specific cell.
func _inc_solidness(x, y):
	_solidness[y * size.x + x] += 1
	print("Solidness at x:", x, " y:", y, " went to:",
		  _solidness[y * size.x + x])

# Decrements solidness by 1 in the specific cell.
func _dec_solidness(x, y):
	_solidness[y * size.x + x] -= 1
	print("Solidness at x:", x, " y:", y, " went to:",
		  _solidness[y * size.x + x])

# Gets the solidness for the specific cell.
func _get_solidness(x, y) -> int:
	return _solidness[y * size.x + x]

# Increments solidness by 1 in the specific row.
func _inc_row_solidness(x, width, y):
	for x_ in range(x, x + width):
		_inc_solidness(x_, y)

# Decrements solidness by 1 in the specific row.
func _dec_row_solidness(x, width, y):
	for x_ in range(x, x + width):
		_dec_solidness(x_, y)

# Increments solidness by 1 in the specified column.
func _inc_col_solidness(x, y, height):
	for y_ in range(y, y + height):
		_inc_solidness(x, y_)

# Decrements solidness by 1 in the specified column.
func _dec_col_solidness(x, y, height):
	for y_ in range(y, y + height):
		_dec_solidness(x, y_)

# Increments an adjacent side of an object.
func _inc_side(x, width, y, height, direction, solidness):
	match direction:
		_Direction.UP:
			match solidness:
				_Solidness.SOLID:
					_inc_row_solidness(x, width, y - 1)
				_Solidness.HOLE:
					_dec_row_solidness(x, width, y - 1)
		_Direction.DOWN:
			match solidness:
				_Solidness.SOLID:
					_inc_row_solidness(x, width, y + height)
				_Solidness.HOLE:
					_dec_row_solidness(x, width, y + height)
		_Direction.LEFT:
			match solidness:
				_Solidness.SOLID:
					_inc_col_solidness(x - 1, y, height)
				_Solidness.HOLE:
					_dec_col_solidness(x - 1, y, height)
		_Direction.RIGHT:
			match solidness:
				_Solidness.SOLID:
					_inc_col_solidness(x + width, y, height)
				_Solidness.HOLE:
					_dec_col_solidness(x + width, y, height)

# Decrements an adjacent side of an object.
func _dec_side(x, width, y, height, direction, solidness):
	match direction:
		_Direction.UP:
			match solidness:
				_Solidness.SOLID:
					_dec_row_solidness(x, width, y - 1)
				_Solidness.HOLE:
					_inc_row_solidness(x, width, y - 1)
		_Direction.DOWN:
			match solidness:
				_Solidness.SOLID:
					_dec_row_solidness(x, width, y + height)
				_Solidness.HOLE:
					_inc_row_solidness(x, width, y + height)
		_Direction.LEFT:
			match solidness:
				_Solidness.SOLID:
					_dec_col_solidness(x - 1, y, height)
				_Solidness.HOLE:
					_inc_col_solidness(x - 1, y, height)
		_Direction.RIGHT:
			match solidness:
				_Solidness.SOLID:
					_dec_col_solidness(x + width, y, height)
				_Solidness.HOLE:
					_inc_col_solidness(x + width, y, height)

# Increments solidness by 1 in the specified square.
func _inc_square_solidness(x, width, y, height):
	for x_ in range(x, x + width):
		for y_ in range(y, y + height):
			_inc_solidness(x_, y_)

# Decrements solidness by 1 in the specified square.
func _dec_square_solidness(x, width, y, height):
	for x_ in range(x, x + width):
		for y_ in range(y, y + height):
			_dec_solidness(x_, y_)

# Increments/Decrements solidness by 1, depending on
# the corresponding solidness mask position.
func _inc_irregular_solidness(x, width, y, height, mask):
	var index = 0
	for y_ in range(y, y + height):
		for x_ in range(x, x + width):
			if mask[index] > 0:
				_inc_solidness(x_, y_)
			elif mask[index] < 0:
				_dec_solidness(x_, y_)
			index += 1

# Decrements/Increments solidness by 1, depending on
# the corresponding solidness mask position.
func _dec_irregular_solidness(x, width, y, height, mask):
	var index = 0
	for y_ in range(y, y + height):
		for x_ in range(x, x + width):
			if mask[index] > 0:
				_dec_solidness(x_, y_)
			elif mask[index] < 0:
				_inc_solidness(x_, y_)
			index += 1

# Increments a body's effect on solidness according to
# the coordinates, dimensions, solidness type and mask.
func _inc_body_solidness(x, width, y, height, solidness, mask):
	match solidness:
		_Solidness.SOLID:
			_inc_square_solidness(x, width, y, height)
		_Solidness.HOLE:
			_dec_square_solidness(x, width, y, height)
		_Solidness.IRREGULAR:
			_inc_irregular_solidness(x, width, y, height, mask)

# Decrements a body's effect on solidness according to
# the coordinates, dimensions, solidness type and mask.
func _dec_body_solidness(x, width, y, height, solidness, mask):
	match solidness:
		_Solidness.SOLID:
			_dec_square_solidness(x, width, y, height)
		_Solidness.HOLE:
			_inc_square_solidness(x, width, y, height)
		_Solidness.IRREGULAR:
			_dec_irregular_solidness(x, width, y, height, mask)

# Tells whether a row has at least 1 blocking.
func _is_row_blocked(x, width, y) -> bool:
	for x_ in range(x, x + width):
		if _get_solidness(x_, y) > 0:
			return true
	return false

# Tells whether a column has at least 1 blocking.
func _is_col_blocked(x, y, height) -> bool:
	for y_ in range(y, y + height):
		if _get_solidness(x, y_) > 0:
			return true
	return false

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the solidness peer rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Solidness.EntityRule

## Tells whether an entity can start moving.
func can_move(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	position: Vector2i, direction: _Direction
) -> bool:
	if entity_rule.solidness == _Solidness.IRREGULAR:
		return false
	if not entity_rule.obeys_solidness:
		return true
	match direction:
		_Direction.UP:
			# precondition: y > 0
			return not _is_row_blocked(position.x, entity_rule.size.x, position.y - 1)
		_Direction.DOWN:
			# precondition: y < ES_H - E_H
			return not _is_row_blocked(
				position.x, entity_rule.size.x,
				position.y + entity_rule.size.y
			)
		_Direction.LEFT:
			# precondition: x > 0
			return not _is_col_blocked(position.x - 1, position.y, entity_rule.size.y)
		_Direction.RIGHT:
			# precondition: x < ES_W - E_W
			return not _is_col_blocked(
				position.x + entity_rule.size.x,
				position.y, entity_rule.size.y
			)
	return false

func on_entity_attached(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	to_position: Vector2i
) -> void:
	_inc_body_solidness(
		to_position.x, entity_rule.size.x,
		to_position.y, entity_rule.size.y,
		entity_rule.solidness, entity_rule.mask
	)

func on_movement_started(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementStartedStage
) -> void:
	match stage:
		MovementStartedStage.MovementAllocated:
			if entity_rule.optimistic:
				_dec_side(
					end_position.x, entity_rule.size.x,
					end_position.y, entity_rule.size.y,
					_DirectionUtils.opposite_direction(direction),
					entity_rule.solidness
				)
			_inc_side(
				start_position.x, entity_rule.size.x,
				start_position.y, entity_rule.size.y,
				direction, entity_rule.solidness
			)

func on_movement_finished(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	stage: MovementConfirmedStage
) -> void:
	match stage:
		MovementConfirmedStage.PositionChanged:
			if entity_rule.optimistic:
				return
			_dec_side(
				end_position.x, entity_rule.size.x,
				end_position.y, entity_rule.size.y,
				_DirectionUtils.opposite_direction(direction),
				entity_rule.solidness
			)

func on_movement_cancelled(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	start_position: Vector2i, reverted_position: Vector2i, direction: _Direction,
	stage: MovementClearedStage
) -> void:
	match stage:
		MovementClearedStage.Begin:
			if entity_rule.optimistic:
				_inc_side(
					reverted_position.x, entity_rule.size.x,
					reverted_position.y, entity_rule.size.y,
					_DirectionUtils.opposite_direction(direction),
					entity_rule.solidness
				)
			_dec_side(
				start_position.x, entity_rule.size.x,
				start_position.y, entity_rule.size.y,
				direction, entity_rule.solidness
			)

func on_teleported(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	from_position: Vector2i, to_position: Vector2i,
	stage: TeleportedStage
) -> void:
	match stage:
		TeleportedStage.Begin:
			_dec_body_solidness(
				from_position.x, entity_rule.size.x,
				from_position.y, entity_rule.size.y,
				entity_rule.solidness, entity_rule.mask
			)
		TeleportedStage.PositionChanged:
			_inc_body_solidness(
				to_position.x, entity_rule.size.x,
				to_position.y, entity_rule.size.y,
				entity_rule.solidness, entity_rule.mask
			)

func on_property_updated(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	property: String, old_value, new_value
) -> void:
	if old_value == new_value:
		return
	if property == "solidness":
		entity_rule.map_entity.cancel_movement()
		_dec_body_solidness(
			entity_rule.map_entity.cell.x, entity_rule.size.x,
			entity_rule.map_entity.cell.y, entity_rule.size.y,
			old_value, entity_rule.mask
		)
		_inc_body_solidness(
			entity_rule.map_entity.cell.x, entity_rule.size.x,
			entity_rule.map_entity.cell.y, entity_rule.size.y,
			new_value, entity_rule.mask
		)
	elif property == "solidness.mask":
		entity_rule.map_entity.cancel_movement()
		_dec_body_solidness(
			entity_rule.map_entity.cell.x, entity_rule.size.x,
			entity_rule.map_entity.cell.y, entity_rule.size.y,
			entity_rule.solidness, old_value
		)
		_inc_body_solidness(
			entity_rule.map_entity.cell.x, entity_rule.size.x,
			entity_rule.map_entity.cell.y, entity_rule.size.y,
			entity_rule.solidness, new_value
		)

func on_entity_detached(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	from_position: Vector2i
) -> void:
	_dec_body_solidness(
		from_position.x, entity_rule.size.x,
		from_position.y, entity_rule.size.y,
		entity_rule.solidness, entity_rule.mask
	)
