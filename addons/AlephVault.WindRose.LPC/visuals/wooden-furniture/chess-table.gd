@tool
extends "./base.gd"


const _REGION_RECT := Rect2i(64, 408, 32, 32)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT
