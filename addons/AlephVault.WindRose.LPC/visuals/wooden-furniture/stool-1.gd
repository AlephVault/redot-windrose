@tool
extends "./base.gd"


const _WORN_REGION_RECT := Rect2i(448, 224, 32, 32)
const _REGION_RECT := Rect2i(448, 256, 32, 32)


## Whether this stool uses the worn visual variant.
@export var worn: bool = false:
	set(value):
		if worn == value:
			return
		worn = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _WORN_REGION_RECT if worn else _REGION_RECT
