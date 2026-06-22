@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _DOWN_REGION_RECT := Rect2i(0, 800, 96, 32)
const _UP_REGION_RECT := Rect2i(96, 800, 96, 32)
const _OFFSET := Vector2.ZERO


func _get_region_rect() -> Rect2i:
	return _DOWN_REGION_RECT


func _get_region_rect_up() -> Rect2i:
	return _UP_REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
