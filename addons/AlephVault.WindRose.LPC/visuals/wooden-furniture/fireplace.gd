@tool
extends "./base.gd"


enum FireplaceType {
	FIREPLACE_TYPE_1,
	FIREPLACE_TYPE_2,
}


const _FIREPLACE_TYPE_REGION_RECTS := {
	FireplaceType.FIREPLACE_TYPE_1: Rect2i(384, 736, 96, 96),
	FireplaceType.FIREPLACE_TYPE_2: Rect2i(416, 928, 96, 96),
}

const _OFFSET := Vector2(0, -64)


## The fireplace visual variant.
@export var fireplace_type: FireplaceType = FireplaceType.FIREPLACE_TYPE_1:
	set(value):
		if fireplace_type == value:
			return
		fireplace_type = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _FIREPLACE_TYPE_REGION_RECTS.get(
		fireplace_type, _FIREPLACE_TYPE_REGION_RECTS[FireplaceType.FIREPLACE_TYPE_1]
	)


func _get_offset() -> Vector2:
	return _OFFSET
