@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum FlowerBedType {
	TYPE_1,
	TYPE_2,
}

const _HORIZONTAL_OFFSET := Vector2.ZERO
const _VERTICAL_OFFSET := Vector2(0, -32)
const _HORIZONTAL_REGION_RECTS := [
	Rect2i(320, 480, 32, 32),
	Rect2i(320, 512, 32, 32),
]
const _VERTICAL_REGION_RECTS := [
	Rect2i(384, 480, 32, 64),
	Rect2i(352, 480, 32, 64),
]


## The flower bed variant to render.
@export var flower_type: FlowerBedType = FlowerBedType.TYPE_1:
	set(value):
		var next_value := clampi(value, 0, FlowerBedType.size() - 1)
		if flower_type == next_value:
			return
		flower_type = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(flower_type), 0, FlowerBedType.size() - 1)


func _get_horizontal_region_rect() -> Rect2i:
	return _HORIZONTAL_REGION_RECTS[_get_key()]


func _get_vertical_region_rect() -> Rect2i:
	return _VERTICAL_REGION_RECTS[_get_key()]


func _get_region_rect() -> Rect2i:
	return _get_horizontal_region_rect()


func _get_offset() -> Vector2:
	return _HORIZONTAL_OFFSET


func _make_full_setup() -> FullSetup:
	return FullSetup.new(StateSetup.new(
		FramesetSetup.new(texture, _get_horizontal_region_rect(), 1, true, false, _HORIZONTAL_OFFSET),
		FramesetSetup.new(texture, _get_horizontal_region_rect(), 1, true, false, _HORIZONTAL_OFFSET),
		FramesetSetup.new(texture, _get_vertical_region_rect(), 1, true, false, _VERTICAL_OFFSET),
		FramesetSetup.new(texture, _get_vertical_region_rect(), 1, true, false, _VERTICAL_OFFSET)
	))
