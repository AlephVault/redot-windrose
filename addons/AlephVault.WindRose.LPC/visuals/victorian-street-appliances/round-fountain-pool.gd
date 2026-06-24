@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


const _SPRITE_SIZE := Vector2i(64, 64)
const _FRAME_COUNT := 4
const _TEXTURE_SIZE := Vector2i(_SPRITE_SIZE.x, _SPRITE_SIZE.y * _FRAME_COUNT)
const _DEFAULT_FPS := 4
const _FRAME_RECTS := [
	Rect2i(0, 320, 64, 64),
	Rect2i(64, 320, 64, 64),
	Rect2i(128, 320, 64, 64),
	Rect2i(64, 320, 64, 64),
]
const _OFFSET := Vector2(0, 0)


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _get_texture_context():
	var steps := []
	for index in _FRAME_RECTS.size():
		steps.push_back(_make_step(
			"round-fountain-pool-frame-" + str(index),
			_FRAME_RECTS[index],
			Vector2i(0, _SPRITE_SIZE.y * index)
		))
	return _make_context(_TEXTURE_SIZE, steps)


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _TEXTURE_SIZE)


func _get_frame_count() -> int:
	return _FRAME_COUNT


func _get_offset() -> Vector2:
	return _OFFSET
