@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum VerticalWoodenPlantBedContent {
	CONTENT_NONE,
	CONTENT_FLOWERS1,
	CONTENT_BUSH,
	CONTENT_FLOWERS2,
}

const _OFFSET := Vector2.ZERO
const _REGION_RECTS := [
	Rect2i(352, 608, 32, 64),
	Rect2i(384, 608, 32, 64),
	Rect2i(352, 672, 32, 64),
	Rect2i(384, 672, 32, 64),
]


## The plant bed content to render.
@export var content: VerticalWoodenPlantBedContent = VerticalWoodenPlantBedContent.CONTENT_NONE:
	set(value):
		var next_value := clampi(value, 0, VerticalWoodenPlantBedContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, VerticalWoodenPlantBedContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
