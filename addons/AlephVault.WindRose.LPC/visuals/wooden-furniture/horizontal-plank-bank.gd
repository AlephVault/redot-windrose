@tool
extends "./base.gd"


const _REGION_RECT := Rect2i(256, 896, 64, 32)
const _OFFSET := Vector2.ZERO


func _get_region_rect() -> Rect2i:
	return _REGION_RECT


func _get_region_rect_up() -> Rect2i:
	return _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
