@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


enum VerticalFurnitureType {
	DRAWERS,
	BOOKSHELVES,
	EMPTIED_BOOKSHELVES,
	DISH_SHELVES,
	EMPTIED_DISH_SHELVES,
	DRAWERS_2,
	EMPTIED_DISH_SHELVES_2,
}


enum VerticalFurnitureLegsType {
	SMALL,
	BIG,
}


const _REGION_SIZE := Vector2i(32, 93)
const _TEXTURE_SIZE := Vector2i(32, 96)
const _TOP_RECT := Rect2i(352, 0, 32, 32)
const _BIG_LEGS_FRONT_RECT := Rect2i(480, 211, 32, 13)
const _OFFSET := Vector2(0, -80)

const _FURNITURE_TYPE_XZ := {
	VerticalFurnitureType.DRAWERS: Vector2i(288, 288),
	VerticalFurnitureType.BOOKSHELVES: Vector2i(352, 352),
	VerticalFurnitureType.EMPTIED_BOOKSHELVES: Vector2i(384, 384),
	VerticalFurnitureType.DISH_SHELVES: Vector2i(416, 416),
	VerticalFurnitureType.EMPTIED_DISH_SHELVES: Vector2i(320, 320),
	VerticalFurnitureType.DRAWERS_2: Vector2i(448, 288),
	VerticalFurnitureType.EMPTIED_DISH_SHELVES_2: Vector2i(480, 448),
}


## The vertical furniture contents variant.
@export var furniture_type: VerticalFurnitureType = VerticalFurnitureType.DRAWERS:
	set(value):
		if furniture_type == value:
			return
		_release_texture()
		furniture_type = value
		_setup_sprite()


## The vertical furniture leg size variant.
@export var furniture_legs_type: VerticalFurnitureLegsType = VerticalFurnitureLegsType.SMALL:
	set(value):
		if furniture_legs_type == value:
			return
		_release_texture()
		furniture_legs_type = value
		_setup_sprite()


func _get_type_xz() -> Vector2i:
	return _FURNITURE_TYPE_XZ.get(
		furniture_type, _FURNITURE_TYPE_XZ[VerticalFurnitureType.DRAWERS]
	)


func _get_texture_context():
	var xz := _get_type_xz()
	var key_suffix := "type-" + str(furniture_type) + "-legs-" + str(furniture_legs_type) + "-tone-" + str(tone)
	var steps := [
		_make_step("vertical-furniture-top-" + key_suffix, _TOP_RECT, Vector2i(0, 0)),
		_make_step("vertical-furniture-middle-" + key_suffix, Rect2i(xz.x, 128, 32, 32), Vector2i(0, 32)),
	]

	if furniture_legs_type == VerticalFurnitureLegsType.SMALL:
		steps.push_back(_make_step(
			"vertical-furniture-small-legs-" + key_suffix,
			Rect2i(xz.x, 160, 32, 27),
			Vector2i(0, 64)
		))
		steps.push_back(_make_step(
			"vertical-furniture-small-legs-front-" + key_suffix,
			Rect2i(480, 187, 32, 5),
			Vector2i(0, 91)
		))
	else:
		steps.push_back(_make_step(
			"vertical-furniture-big-legs-" + key_suffix,
			Rect2i(xz.y, 192, 32, 32),
			Vector2i(0, 64)
		))
		steps.push_back(_make_step(
			"vertical-furniture-big-legs-front-" + key_suffix,
			_BIG_LEGS_FRONT_RECT,
			Vector2i(0, 83)
		))

	return _make_context(_TEXTURE_SIZE, steps)


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _REGION_SIZE)


func _get_offset() -> Vector2:
	return _OFFSET
