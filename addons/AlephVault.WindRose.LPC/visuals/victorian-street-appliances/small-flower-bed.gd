@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum FlowerBedLayout {
	HORIZONTAL,
	VERTICAL,
}

enum FlowerBedType {
	TYPE_1,
	TYPE_2,
}

const _HORIZONTAL_OFFSET := Vector2.ZERO
const _VERTICAL_OFFSET := Vector2(0, -32)
const _REGION_RECTS := {
	0: Rect2i(320, 480, 32, 32),
	1: Rect2i(320, 512, 32, 32),
	2: Rect2i(384, 480, 32, 64),
	3: Rect2i(352, 480, 32, 64),
}


## The flower bed layout to render.
@export var layout: FlowerBedLayout = FlowerBedLayout.HORIZONTAL:
	set(value):
		var next_value := clampi(value, 0, FlowerBedLayout.size() - 1)
		if layout == next_value:
			return
		layout = next_value
		_setup_sprite()


## The flower bed variant to render.
@export var flower_type: FlowerBedType = FlowerBedType.TYPE_1:
	set(value):
		var next_value := clampi(value, 0, FlowerBedType.size() - 1)
		if flower_type == next_value:
			return
		flower_type = next_value
		_setup_sprite()


func _get_key() -> int:
	return int(layout) * FlowerBedType.size() + int(flower_type)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS.get(_get_key(), _REGION_RECTS[0])


func _get_offset() -> Vector2:
	return _VERTICAL_OFFSET if layout == FlowerBedLayout.VERTICAL else _HORIZONTAL_OFFSET
