@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _WORN_REGION_RECT := Rect2i(480, 288, 32, 32)
const _REGION_RECT := Rect2i(480, 352, 32, 32)
const _OFFSET := Vector2(0, -16)


## Whether this night stand uses the worn visual variant.
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
