@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum TableType {
	TABLE_WOODEN1,
	TABLE_WOODEN2,
	TABLE_METAL1,
	TABLE_METAL2,
	TABLE_METAL3,
}

const _OFFSET := Vector2.ZERO
const _REGION_RECTS := [
	Rect2i(960, 0, 32, 32),
	Rect2i(960, 32, 32, 32),
	Rect2i(992, 96, 32, 32),
	Rect2i(992, 128, 32, 32),
	Rect2i(992, 160, 32, 32),
]


## The table visual variant.
@export var table_type: TableType = TableType.TABLE_WOODEN1:
	set(value):
		var next_value := clampi(value, 0, TableType.size() - 1)
		if table_type == next_value:
			return
		table_type = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(table_type), 0, TableType.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
