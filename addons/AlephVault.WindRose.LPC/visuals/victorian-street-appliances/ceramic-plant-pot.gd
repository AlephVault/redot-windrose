@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum CeramicPlantPotContent {
	CONTENT_NONE,
	CONTENT_DIRT,
	CONTENT_PINE,
	CONTENT_TREE1,
	CONTENT_TREE2,
	CONTENT_TREE3,
	CONTENT_FLOWERS_RED,
	CONTENT_FLOWERS_LITEBLUE,
	CONTENT_ROSES,
	CONTENT_SUNFLOWERS,
	CONTENT_BUSH,
}

const _EMPTY_OFFSET := Vector2.ZERO
const _FILLED_OFFSET := Vector2(0, -32)
const _REGION_RECTS := [
	Rect2i(192, 544, 32, 32),
	Rect2i(192, 576, 32, 32),
	Rect2i(224, 544, 32, 64),
	Rect2i(256, 544, 32, 64),
	Rect2i(288, 544, 32, 64),
	Rect2i(320, 544, 32, 64),
	Rect2i(352, 544, 32, 64),
	Rect2i(384, 544, 32, 64),
	Rect2i(416, 544, 32, 64),
	Rect2i(448, 544, 32, 64),
	Rect2i(480, 544, 32, 64),
]


## The plant pot content to render.
@export var content: CeramicPlantPotContent = CeramicPlantPotContent.CONTENT_NONE:
	set(value):
		var next_value := clampi(value, 0, CeramicPlantPotContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, CeramicPlantPotContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _EMPTY_OFFSET if content in [
		CeramicPlantPotContent.CONTENT_NONE,
		CeramicPlantPotContent.CONTENT_DIRT,
	] else _FILLED_OFFSET
