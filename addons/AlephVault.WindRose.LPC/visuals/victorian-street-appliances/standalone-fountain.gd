@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum FountainType {
	FOUNTAIN_TYPE_1,
	FOUNTAIN_TYPE_2,
}

const _SPRITE_SIZE := Vector2i(64, 96)
const _FRAME_COUNT := 4
const _TEXTURE_SIZE := Vector2i(_SPRITE_SIZE.x, _SPRITE_SIZE.y * _FRAME_COUNT)
const _DEFAULT_FPS := 4
const _BOTTOM_FRAME_SEQUENCE := [0, 1, 2, 1]
const _BOTTOM_FRAME_X := [0, 64, 128]
const _BOTTOM_FRAME_Y := {
	FountainType.FOUNTAIN_TYPE_1: 400,
	FountainType.FOUNTAIN_TYPE_2: 464,
}
const _TOP_FRAME_RECTS := [
	Rect2i(208, 416, 64, 64),
	Rect2i(304, 416, 64, 64),
	Rect2i(400, 416, 64, 64),
	Rect2i(304, 416, 64, 64),
]
const _OFFSET := Vector2(0, -32)


## The standalone fountain visual variant.
@export var fountain_type: FountainType = FountainType.FOUNTAIN_TYPE_1:
	set(value):
		var next_value := clampi(value, 0, FountainType.size() - 1)
		if fountain_type == next_value:
			return
		_release_textures()
		fountain_type = next_value
		_setup_sprite()


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _get_texture_context():
	var steps := []
	var bottom_y: int = _BOTTOM_FRAME_Y.get(
		fountain_type, _BOTTOM_FRAME_Y[FountainType.FOUNTAIN_TYPE_1]
	)
	for index in _FRAME_COUNT:
		var frame_y := _SPRITE_SIZE.y * index
		var bottom_frame: int = _BOTTOM_FRAME_SEQUENCE[index]
		steps.push_back(_make_step(
			"standalone-fountain-" + str(fountain_type) + "-bottom-" + str(index),
			Rect2i(_BOTTOM_FRAME_X[bottom_frame], bottom_y, 64, 48),
			Vector2i(0, frame_y + 48)
		))
		steps.push_back(_make_step(
			"standalone-fountain-top-" + str(index),
			_TOP_FRAME_RECTS[index],
			Vector2i(0, frame_y)
		))
	return _make_context(_TEXTURE_SIZE, steps)


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _TEXTURE_SIZE)


func _get_frame_count() -> int:
	return _FRAME_COUNT


func _get_offset() -> Vector2:
	return _OFFSET
