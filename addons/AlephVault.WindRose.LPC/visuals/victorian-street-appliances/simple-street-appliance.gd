@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum SimpleStreetApplianceType {
	GRAY_MAILBOX,
	SQUARED_TRASHBIN,
	ROUNDED_TRASHBIN,
	HYDRANT,
	GREEN_MAILBOX,
	ORANGE_MAILBOX,
}

const _REGION_BASE := Vector2i(736, 0)
const _REGION_SIZE := Vector2i(32, 64)
const _OFFSET := Vector2(0, -32)


## The street appliance variant to render.
@export var appliance: SimpleStreetApplianceType = SimpleStreetApplianceType.GRAY_MAILBOX:
	set(value):
		var next_value := clampi(value, 0, SimpleStreetApplianceType.size() - 1)
		if appliance == next_value:
			return
		appliance = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(appliance), 0, SimpleStreetApplianceType.size() - 1)


func _get_region_rect() -> Rect2i:
	return Rect2i(
		_REGION_BASE + Vector2i(_REGION_SIZE.x * _get_key(), 0),
		_REGION_SIZE
	)


func _get_offset() -> Vector2:
	return _OFFSET
