@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _SPRITE_SIZE := Vector2i(32, 32)


enum ChairType {
	CHAIR_TYPE_1,
	CHAIR_TYPE_2,
	CHAIR_TYPE_3,
	CHAIR_TYPE_4,
	CHAIR_TYPE_5,
	CHAIR_TYPE_6,
	CHAIR_TYPE_7,
}


const _CHAIR_TYPE_GROUP_COORDINATES := {
	ChairType.CHAIR_TYPE_1: Vector2i(448, 480),
	ChairType.CHAIR_TYPE_2: Vector2i(384, 544),
	ChairType.CHAIR_TYPE_3: Vector2i(448, 544),
	ChairType.CHAIR_TYPE_4: Vector2i(384, 608),
	ChairType.CHAIR_TYPE_5: Vector2i(448, 608),
	ChairType.CHAIR_TYPE_6: Vector2i(384, 672),
	ChairType.CHAIR_TYPE_7: Vector2i(448, 672),
}

const _CHAIR_TYPE_1_WORN_GROUP_COORDINATES := Vector2i(384, 480)


## The chair visual variant.
@export var chair_type: ChairType = ChairType.CHAIR_TYPE_1:
	set(value):
		if chair_type == value:
			return
		chair_type = value
		_setup_sprite()


## Whether this chair uses the worn visual variant.
@export var worn: bool = false:
	set(value):
		if worn == value:
			return
		worn = value
		_setup_sprite()


func _get_group_coordinates() -> Vector2i:
	if chair_type == ChairType.CHAIR_TYPE_1 and worn:
		return _CHAIR_TYPE_1_WORN_GROUP_COORDINATES
	return _CHAIR_TYPE_GROUP_COORDINATES.get(
		chair_type, _CHAIR_TYPE_GROUP_COORDINATES[ChairType.CHAIR_TYPE_1]
	)


func _get_region_rect() -> Rect2i:
	return Rect2i(_get_group_coordinates(), _SPRITE_SIZE)


func _get_region_rect_up() -> Rect2i:
	return Rect2i(_get_group_coordinates() + Vector2i(32, 0), _SPRITE_SIZE)


func _get_region_rect_left() -> Rect2i:
	return Rect2i(_get_group_coordinates() + Vector2i(32, 32), _SPRITE_SIZE)


func _get_region_rect_right() -> Rect2i:
	return Rect2i(_get_group_coordinates() + Vector2i(0, 32), _SPRITE_SIZE)
