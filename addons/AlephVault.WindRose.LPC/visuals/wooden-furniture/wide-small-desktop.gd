@tool
extends "./base.gd"


const _WORN_REGION_RECT := Rect2i(128, 304, 64, 48)
const _REGION_RECT := Rect2i(128, 304, 64, 48)
const _OFFSET := Vector2(0, -32)


## Whether this desktop uses the worn visual variant.
@export var worn: bool = false:
	set(value):
		if worn == value:
			return
		worn = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _WORN_REGION_RECT if worn else _REGION_RECT


func _get_offset() -> Vector2:
	return _OFFSET
