@tool
extends "./base.gd"


const _DOWN_REGION_RECT := Rect2i(0, 800, 96, 32)
const _UP_REGION_RECT := Rect2i(96, 800, 96, 32)


func _get_region_rect() -> Rect2i:
	return _DOWN_REGION_RECT


func _get_region_rect_up() -> Rect2i:
	return _UP_REGION_RECT
