@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum SmallMarketBoxType {
	BOX_DARK,
	BOX_LIGHT,
	BOX_MID,
}

const _OFFSET := Vector2.ZERO
const _REGION_RECTS := [
	Rect2i(800, 192, 32, 32),
	Rect2i(800, 224, 32, 32),
	Rect2i(800, 256, 32, 32),
]


## The market box visual variant.
@export var box_type: SmallMarketBoxType = SmallMarketBoxType.BOX_DARK:
	set(value):
		var next_value := clampi(value, 0, SmallMarketBoxType.size() - 1)
		if box_type == next_value:
			return
		box_type = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(box_type), 0, SmallMarketBoxType.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
