@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum StreetClockType {
	CLOCK_TYPE_1,
	CLOCK_TYPE_2,
}

const _SPRITE_SIZE := Vector2i(32, 96)
const _OFFSET := Vector2(0, -64)


## The street clock variant to render.
@export var clock_type: StreetClockType = StreetClockType.CLOCK_TYPE_1:
	set(value):
		var next_value := clampi(value, 0, StreetClockType.size() - 1)
		if clock_type == next_value:
			return
		_release_textures()
		clock_type = next_value
		_setup_sprite()


func _get_texture_context():
	match clock_type:
		StreetClockType.CLOCK_TYPE_2:
			return _make_context(_SPRITE_SIZE, [
				_make_step("street-clock-2-post", Rect2i(160, 32, 32, 32), Vector2i(0, 64)),
				_make_step("street-clock-2-clock", Rect2i(192, 0, 32, 64), Vector2i.ZERO),
			])
		_:
			return _make_context(_SPRITE_SIZE, [
				_make_step("street-clock-1-post", Rect2i(128, 0, 32, 64), Vector2i(0, 32)),
				_make_step("street-clock-1-clock", Rect2i(160, 0, 32, 32), Vector2i.ZERO),
			])


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _SPRITE_SIZE)


func _get_offset() -> Vector2:
	return _OFFSET
