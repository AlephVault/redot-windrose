@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


const _REGION_RECT := Rect2i(192, 672, 96, 96)
const _OFFSET := Vector2.ZERO


func _get_region_rect() -> Rect2i:
	return _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
