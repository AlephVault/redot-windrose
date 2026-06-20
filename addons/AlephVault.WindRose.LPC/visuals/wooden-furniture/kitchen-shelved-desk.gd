@tool
extends "./base.gd"


const _REGION_RECT := Rect2i(256, 0, 32, 64)
const _OFFSET := Vector2(0, -32)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
