@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum RoundedBushPotContent {
	CONTENT_DIRT,
	CONTENT_DAISIES_BUSH,
	CONTENT_SPIKY_BUSH,
}

const _OFFSET := Vector2.ZERO
const _REGION_RECTS := [
	Rect2i(0, 768, 64, 64),
	Rect2i(0, 832, 64, 64),
	Rect2i(0, 896, 64, 64),
]


## The bush pot content to render.
@export var content: RoundedBushPotContent = RoundedBushPotContent.CONTENT_DIRT:
	set(value):
		var next_value := clampi(value, 0, RoundedBushPotContent.size() - 1)
		if content == next_value:
			return
		content = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(content), 0, RoundedBushPotContent.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
