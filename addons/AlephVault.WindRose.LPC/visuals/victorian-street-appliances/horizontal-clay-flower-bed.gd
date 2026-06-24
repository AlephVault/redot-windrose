@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum HorizontalClayFlowerBedContent {
	CONTENT_DIRT,
	CONTENT_BUSH,
	CONTENT_BUSHES,
	CONTENT_FLOWER_PURPLE,
	CONTENT_FLOWER_WHITE,
	CONTENT_FLOWER_YELLOW,
	CONTENT_FLOWER_ROSES_AND_YELLOW,
	CONTENT_FLOWER_RED,
	CONTENT_FLOWER_ORANGE,
	CONTENT_FLOWER_LITEBLUE,
	CONTENT_FLOWER_ROSES_AND_PURPLE,
	CONTENT_FLOWERS_PURPLE2,
}

const _REGION_SIZE := Vector2i(96, 64)
const _REGION_BASE := Vector2i(64, 768)
const _OFFSET := Vector2(0, -16)


## The flower bed content to render.
@export var content: HorizontalClayFlowerBedContent = HorizontalClayFlowerBedContent.CONTENT_DIRT:
	set(value):
		var next_value := clampi(value, 0, HorizontalClayFlowerBedContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, HorizontalClayFlowerBedContent.size() - 1)


func _get_region_rect() -> Rect2i:
	var index := _get_key()
	var region_position := Vector2i(
		_REGION_BASE.x + int(index / 3) * _REGION_SIZE.x,
		_REGION_BASE.y + (index % 3) * _REGION_SIZE.y
	)
	return Rect2i(region_position, _REGION_SIZE)


func _get_offset() -> Vector2:
	return _OFFSET
