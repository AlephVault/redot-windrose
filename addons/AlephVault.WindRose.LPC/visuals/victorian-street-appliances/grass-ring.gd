@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


const _REGION_RECT := Rect2i(352, 256, 64, 64)
const _OFFSET := Vector2(0, 0)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
