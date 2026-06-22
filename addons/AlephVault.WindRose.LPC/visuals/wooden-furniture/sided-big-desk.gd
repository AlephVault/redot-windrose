@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _RIGHT_REGION_RECT := Rect2i(0, 704, 32, 96)
const _LEFT_REGION_RECT := Rect2i(32, 704, 32, 96)
const _OFFSET := Vector2(0, -32)


func _get_region_rect() -> Rect2i:
	return _RIGHT_REGION_RECT


func _get_region_rect_left() -> Rect2i:
	return _LEFT_REGION_RECT


func _get_region_rect_right() -> Rect2i:
	return _RIGHT_REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
