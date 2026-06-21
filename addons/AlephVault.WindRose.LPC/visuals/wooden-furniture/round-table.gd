@tool
extends "./base.gd"


const _REGION_RECT := Rect2i(224, 224, 64, 64)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT
