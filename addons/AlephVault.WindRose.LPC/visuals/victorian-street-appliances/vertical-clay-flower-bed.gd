@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum VerticalClayFlowerBedContent {
	CONTENT_DIRT,
	CONTENT_BUSH_PURPLE_FLOWERS,
	CONTENT_BUSH_YELLOW_FLOWERS,
	CONTENT_PURPLE_FLOWERS,
	CONTENT_LITEBLUE_FLOWERS,
	CONTENT_RED_FLOWERS,
}

const _OFFSET := Vector2(-16, -16)
const _REGION_RECTS := [
	Rect2i(0, 576, 64, 96),
	Rect2i(64, 576, 64, 96),
	Rect2i(128, 576, 64, 96),
	Rect2i(0, 672, 64, 96),
	Rect2i(64, 672, 64, 96),
	Rect2i(128, 672, 64, 96),
]


## The flower bed content to render.
@export var content: VerticalClayFlowerBedContent = VerticalClayFlowerBedContent.CONTENT_DIRT:
	set(value):
		var next_value := clampi(value, 0, VerticalClayFlowerBedContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, VerticalClayFlowerBedContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
