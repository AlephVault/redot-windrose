@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum MarketPostRoofType {
	ROOF_GRAY,
	ROOF_GREEN,
}

enum MarketPostSignType {
	SIGN_METAL1,
	SIGN_METAL2,
	SIGN_METAL3,
	SIGN_WOOD1,
	SIGN_WOOD2,
	SIGN_WOOD3,
}

enum MarketPostBoxType {
	BOX_DARK,
	BOX_LIGHT,
	BOX_MID,
}

const _SPRITE_SIZE := Vector2i(64, 128)
const _OFFSET := Vector2(0, -64)
const _POST_RECT := Rect2i(832, 384, 64, 64)
const _METAL_SIGN_BASE_RECT := Rect2i(832, 352, 64, 32)
const _WOOD_SIGN_BASE_RECT := Rect2i(896, 352, 64, 32)
const _SIGN_RECTS := [
	Rect2i(832, 192, 64, 32),
	Rect2i(832, 224, 64, 32),
	Rect2i(832, 256, 64, 32),
	Rect2i(896, 192, 64, 32),
	Rect2i(896, 224, 64, 32),
	Rect2i(896, 256, 64, 32),
]
const _ROOF_RECTS := [
	Rect2i(736, 288, 64, 64),
	Rect2i(736, 352, 64, 64),
]
const _BOX_RECTS := [
	Rect2i(736, 192, 64, 32),
	Rect2i(736, 224, 64, 32),
	Rect2i(736, 256, 64, 32),
]


## The market post roof variant.
@export var roof_type: MarketPostRoofType = MarketPostRoofType.ROOF_GRAY:
	set(value):
		var next_value := clampi(value, 0, MarketPostRoofType.size() - 1)
		if roof_type == next_value:
			return
		_release_textures()
		roof_type = next_value
		_setup_sprite()


## The market post sign variant.
@export var sign_type: MarketPostSignType = MarketPostSignType.SIGN_METAL1:
	set(value):
		var next_value := clampi(value, 0, MarketPostSignType.size() - 1)
		if sign_type == next_value:
			return
		_release_textures()
		sign_type = next_value
		_setup_sprite()


## The market post box variant.
@export var box_type: MarketPostBoxType = MarketPostBoxType.BOX_DARK:
	set(value):
		var next_value := clampi(value, 0, MarketPostBoxType.size() - 1)
		if box_type == next_value:
			return
		_release_textures()
		box_type = next_value
		_setup_sprite()


func _get_roof_key() -> int:
	return clampi(int(roof_type), 0, MarketPostRoofType.size() - 1)


func _get_sign_key() -> int:
	return clampi(int(sign_type), 0, MarketPostSignType.size() - 1)


func _get_box_key() -> int:
	return clampi(int(box_type), 0, MarketPostBoxType.size() - 1)


func _get_sign_base_rect() -> Rect2i:
	return _WOOD_SIGN_BASE_RECT if _get_sign_key() >= MarketPostSignType.SIGN_WOOD1 else _METAL_SIGN_BASE_RECT


func _get_texture_context():
	var sign_key := _get_sign_key()
	var roof_key := _get_roof_key()
	var box_key := _get_box_key()
	return _make_context(_SPRITE_SIZE, [
		_make_step("market-post-post", _POST_RECT, Vector2i(0, 48)),
		_make_step("market-post-sign-base-" + str(sign_key), _get_sign_base_rect(), Vector2i(0, 80)),
		_make_step("market-post-sign-" + str(sign_key), _SIGN_RECTS[sign_key], Vector2i(0, 64)),
		_make_step("market-post-roof-" + str(roof_key), _ROOF_RECTS[roof_key], Vector2i.ZERO),
		_make_step("market-post-box-" + str(box_key), _BOX_RECTS[box_key], Vector2i(0, 96)),
	])


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _SPRITE_SIZE)


func _get_offset() -> Vector2:
	return _OFFSET
