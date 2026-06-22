@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


enum BigDeskType {
	DESK_TYPE_1,
	DESK_TYPE_2,
}


const _DESK_TYPE_REGION_RECTS := {
	BigDeskType.DESK_TYPE_1: Rect2i(64, 704, 64, 64),
	BigDeskType.DESK_TYPE_2: Rect2i(128, 704, 64, 64),
}

const _OFFSET := Vector2(0, -32)


## The big desk visual variant.
@export var desk_type: BigDeskType = BigDeskType.DESK_TYPE_1:
	set(value):
		if desk_type == value:
			return
		desk_type = value
		_setup_sprite()


func _get_region_rect() -> Rect2i:
	return _DESK_TYPE_REGION_RECTS.get(
		desk_type, _DESK_TYPE_REGION_RECTS[BigDeskType.DESK_TYPE_1]
	)


func _get_offset() -> Vector2:
	return _OFFSET
