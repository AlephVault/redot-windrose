@tool
extends "./base.gd"


enum TinyDrawerType {
	TINY_DRAWER_1,
	TINY_DRAWER_2,
}


const _DRAWER_TYPE_REGION_RECTS := {
	TinyDrawerType.TINY_DRAWER_1: Rect2i(192, 736, 32, 32),
	TinyDrawerType.TINY_DRAWER_2: Rect2i(224, 768, 32, 32),
}

const _OFFSET := Vector2(0, -16)


## The double tiny drawer visual variant.
@export var drawer_type: TinyDrawerType = TinyDrawerType.TINY_DRAWER_1:
	set(value):
		if drawer_type == value:
			return
		drawer_type = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _DRAWER_TYPE_REGION_RECTS.get(
		drawer_type, _DRAWER_TYPE_REGION_RECTS[TinyDrawerType.TINY_DRAWER_1]
	)


func _get_offset() -> Vector2:
	return _OFFSET
