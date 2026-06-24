@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum TinyWoodenPlantBedContent {
	CONTENT_NONE,
	CONTENT_DIRT,
	CONTENT_BUSH,
}

const _EMPTY_OFFSET := Vector2.ZERO
const _BUSH_OFFSET := Vector2(0, -32)
const _REGION_RECTS := [
	Rect2i(480, 608, 32, 32),
	Rect2i(480, 640, 32, 32),
	Rect2i(480, 672, 32, 64),
]


## The plant bed content to render.
@export var content: TinyWoodenPlantBedContent = TinyWoodenPlantBedContent.CONTENT_NONE:
	set(value):
		var next_value := clampi(value, 0, TinyWoodenPlantBedContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, TinyWoodenPlantBedContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _BUSH_OFFSET if content == TinyWoodenPlantBedContent.CONTENT_BUSH else _EMPTY_OFFSET
