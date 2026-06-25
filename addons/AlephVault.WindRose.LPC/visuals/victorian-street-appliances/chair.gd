@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum ChairType {
	CHAIR_WOODEN,
	CHAIR_METAL,
}

const _OFFSET := Vector2.ZERO
const _METAL_DOWN_OFFSET := Vector2(0, -32)
const _WOODEN_RECTS := {
	"up": Rect2i(992, 0, 32, 32),
	"down": Rect2i(928, 0, 32, 32),
	"left": Rect2i(992, 32, 32, 32),
	"right": Rect2i(928, 32, 32, 32),
}
const _METAL_RECTS := {
	"up": Rect2i(992, 224, 32, 32),
	"down": Rect2i(960, 192, 32, 64),
	"left": Rect2i(992, 256, 32, 32),
	"right": Rect2i(960, 256, 32, 32),
}


## The chair visual variant.
@export var chair_type: ChairType = ChairType.CHAIR_WOODEN:
	set(value):
		var next_value := clampi(value, 0, ChairType.size() - 1)
		if chair_type == next_value:
			return
		chair_type = next_value
		_setup_sprite()


func _get_rects() -> Dictionary:
	return _METAL_RECTS if chair_type == ChairType.CHAIR_METAL else _WOODEN_RECTS


func _get_region_rect() -> Rect2i:
	return _get_rects()["down"]


func _get_offset() -> Vector2:
	return _METAL_DOWN_OFFSET if chair_type == ChairType.CHAIR_METAL else _OFFSET


func _make_full_setup() -> FullSetup:
	var rects := _get_rects()
	var down_offset := _METAL_DOWN_OFFSET if chair_type == ChairType.CHAIR_METAL else _OFFSET
	return FullSetup.new(StateSetup.new(
		FramesetSetup.new(texture, rects["down"], 1, true, false, down_offset),
		FramesetSetup.new(texture, rects["up"], 1, true, false, _OFFSET),
		FramesetSetup.new(texture, rects["left"], 1, true, false, _OFFSET),
		FramesetSetup.new(texture, rects["right"], 1, true, false, _OFFSET)
	))
