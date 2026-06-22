@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


const STATE_OFF := AlephVault__WindRose.Maps.MapEntity.STATE_IDLE
const STATE_ON := AlephVault__WindRose.Maps.MapEntity.STATE_MOVING

enum LampType {
	LAMP_TYPE_1,
	LAMP_TYPE_2,
	LAMP_TYPE_3,
	LAMP_TYPE_4,
	LAMP_TYPE_5,
	LAMP_TYPE_6,
	LAMP_TYPE_7,
	LAMP_TYPE_8,
	LAMP_TYPE_9,
	LAMP_TYPE_10,
}

const _SPRITE_SIZE := Vector2i(32, 96)
const _ON_FRAME_COUNT := 4
const _ON_FRAME_SEQUENCE := [0, 1, 0, 2]
const _OFF_TEXTURE_SIZE := _SPRITE_SIZE
const _ON_TEXTURE_SIZE := Vector2i(_SPRITE_SIZE.x, _SPRITE_SIZE.y * _ON_FRAME_COUNT)
const _DEFAULT_FPS := 4
const _OFFSET := Vector2(0, -64)


## The lamp head style to render.
@export var lamp_type: LampType = LampType.LAMP_TYPE_1:
	set(value):
		var next_value := clampi(value, 0, LampType.size() - 1)
		if lamp_type == next_value:
			return
		_release_textures()
		lamp_type = next_value
		_setup_sprite()


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _get_texture_contexts() -> Array:
	var style_x := 64 + 32 * int(lamp_type)
	var off_steps := [
		_make_step("fancy-off-post", Rect2i(64, 0, 32, 64), Vector2i(0, 32)),
		_make_step("fancy-off-lamp-" + str(lamp_type), Rect2i(style_x, 64, 32, 32), Vector2i.ZERO),
	]
	var on_steps := []
	for index in _ON_FRAME_COUNT:
		var frame_y := _SPRITE_SIZE.y * index
		var flame_frame: int = _ON_FRAME_SEQUENCE[index]
		on_steps.push_back(_make_step(
			"fancy-on-post-" + str(index),
			Rect2i(64, 0, 32, 64),
			Vector2i(0, frame_y + 32)
		))
		on_steps.push_back(_make_step(
			"fancy-on-light-" + str(lamp_type) + "-" + str(index) + "-" + str(flame_frame),
			Rect2i(style_x, 96 + 32 * flame_frame, 32, 32),
			Vector2i(0, frame_y)
		))
	return [
		_make_context(_OFF_TEXTURE_SIZE, off_steps),
		_make_context(_ON_TEXTURE_SIZE, on_steps),
	]


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _OFF_TEXTURE_SIZE)


func _get_frame_count() -> int:
	return 1


func _make_full_setup() -> FullSetup:
	return FullSetup.new(
		StateSetup.new(_make_frameset_setup(
			Rect2i(Vector2i.ZERO, _OFF_TEXTURE_SIZE),
			1,
			_get_cached_texture(0)
		)),
		{
			STATE_ON: StateSetup.new(_make_frameset_setup(
				Rect2i(Vector2i.ZERO, _ON_TEXTURE_SIZE),
				_ON_FRAME_COUNT,
				_get_cached_texture(1)
			)),
		}
	)


func _get_offset() -> Vector2:
	return _OFFSET
