@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum SmallWoodenPlantPotContent {
	CONTENT_NONE,
	CONTENT_DIRT,
	CONTENT_PINE,
	CONTENT_BUSH,
	CONTENT_TREE,
}

const _EMPTY_OFFSET := Vector2.ZERO
const _FILLED_OFFSET := Vector2(0, -32)
const _REGION_RECTS := [
	Rect2i(288, 480, 32, 32),
	Rect2i(288, 512, 32, 32),
	Rect2i(192, 480, 32, 64),
	Rect2i(224, 480, 32, 64),
	Rect2i(256, 480, 32, 64),
]


## The plant pot content to render.
@export var content: SmallWoodenPlantPotContent = SmallWoodenPlantPotContent.CONTENT_NONE:
	set(value):
		var next_value := clampi(value, 0, SmallWoodenPlantPotContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, SmallWoodenPlantPotContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _EMPTY_OFFSET if content in [
		SmallWoodenPlantPotContent.CONTENT_NONE,
		SmallWoodenPlantPotContent.CONTENT_DIRT,
	] else _FILLED_OFFSET
