@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _REGION_RECT := Rect2i(0, 832, 64, 96)
const _OFFSET := Vector2(0, -32)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
