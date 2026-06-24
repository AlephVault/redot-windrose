@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum SmallHorizontalClayFlowerBedContent {
	CONTENT_DIRT,
	CONTENT_BUSH,
}

const _OFFSET := Vector2(0, -32)
const _REGION_RECTS := [
	Rect2i(0, 512, 64, 64),
	Rect2i(64, 512, 64, 64),
]


## The flower bed content to render.
@export var content: SmallHorizontalClayFlowerBedContent = SmallHorizontalClayFlowerBedContent.CONTENT_DIRT:
	set(value):
		var next_value := clampi(value, 0, SmallHorizontalClayFlowerBedContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, SmallHorizontalClayFlowerBedContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
