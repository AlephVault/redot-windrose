@tool
extends "./base.gd"


enum BedType {
	BED_TYPE_1,
	BED_TYPE_2,
	BED_TYPE_3,
}


const _BED_TYPE_REGION_RECTS := {
	BedType.BED_TYPE_1: Rect2i(416, 416, 32, 64),
	BedType.BED_TYPE_2: Rect2i(448, 418, 32, 64),
	BedType.BED_TYPE_3: Rect2i(480, 416, 32, 64),
}

const _OFFSET := Vector2.ZERO


## The twin bed visual variant.
@export var bed_type: BedType = BedType.BED_TYPE_1:
	set(value):
		if bed_type == value:
			return
		bed_type = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _BED_TYPE_REGION_RECTS.get(bed_type, _BED_TYPE_REGION_RECTS[BedType.BED_TYPE_1])


func _get_offset() -> Vector2:
	return _OFFSET
