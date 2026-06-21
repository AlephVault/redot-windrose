@tool
extends "./base.gd"


const _REGION_RECT := Rect2i(480, 736, 32, 96)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT
