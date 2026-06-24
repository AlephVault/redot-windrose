@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


const _SPRITE_SIZE := Vector2i(96, 96)
const _FRAME_COUNT := 4
const _TEXTURE_SIZE := Vector2i(_SPRITE_SIZE.x, _SPRITE_SIZE.y * _FRAME_COUNT)
const _DEFAULT_FPS := 4
const _FRAME_RECTS := [
	Rect2i(192, 320, 96, 96),
	Rect2i(288, 320, 96, 96),
	Rect2i(384, 320, 96, 96),
	Rect2i(288, 320, 96, 96),
]
const _OFFSET := Vector2(0, -32)


## Whether the fountain overlay details should be composed on top of each frame.
@export var include_fountain: bool = true:
	set(value):
		if include_fountain == value:
			return
		_release_textures()
		include_fountain = value
		_setup_sprite()


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _get_texture_context():
	var steps := []
	for index in _FRAME_RECTS.size():
		var source_rect: Rect2i = _FRAME_RECTS[index]
		var frame_position := Vector2i(0, _SPRITE_SIZE.y * index)
		steps.push_back(_make_step(
			"big-square-fountain-pool-frame-" + str(index) + "-base",
			source_rect,
			frame_position
		))
		if include_fountain:
			steps.push_back(_make_step(
				"big-square-fountain-pool-frame-" + str(index) + "-font",
				Rect2i(source_rect.position + Vector2i(0, 96), Vector2i(96, 64)),
				frame_position
			))
	return _make_context(_TEXTURE_SIZE, steps)


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _TEXTURE_SIZE)


func _get_frame_count() -> int:
	return _FRAME_COUNT


func _get_offset() -> Vector2:
	return _OFFSET
