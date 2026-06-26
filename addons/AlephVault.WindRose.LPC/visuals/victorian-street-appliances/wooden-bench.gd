@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum WoodenBenchType {
	BENCH_BROWN,
	BENCH_RED,
}

const _OFFSET := Vector2(0, -32)
const _UP_OFFSET := Vector2.ZERO
const _BROWN_RECTS := {
	"up": Rect2i(832, 160, 32, 32),
	"down": Rect2i(800, 128, 32, 64),
	"left": Rect2i(768, 128, 32, 64),
	"right": Rect2i(736, 128, 32, 64),
}
const _RED_RECTS := {
	"up": Rect2i(960, 160, 32, 32),
	"down": Rect2i(928, 128, 32, 64),
	"left": Rect2i(896, 128, 32, 64),
	"right": Rect2i(864, 128, 32, 64),
}


## The wooden bench visual variant.
@export var bench_type: WoodenBenchType = WoodenBenchType.BENCH_BROWN:
	set(value):
		var next_value := clampi(value, 0, WoodenBenchType.size() - 1)
		if bench_type == next_value:
			return
		bench_type = next_value
		_setup_sprite()


func _get_rects() -> Dictionary:
	return _RED_RECTS if bench_type == WoodenBenchType.BENCH_RED else _BROWN_RECTS


func _get_region_rect() -> Rect2i:
	return _get_rects()["down"]


func _get_offset() -> Vector2:
	return _OFFSET


func _make_full_setup() -> FullSetup:
	var rects := _get_rects()
	return FullSetup.new(StateSetup.new(
		FramesetSetup.new(texture, rects["down"], 1, true, false, _OFFSET),
		FramesetSetup.new(texture, rects["up"], 1, true, false, _UP_OFFSET),
		FramesetSetup.new(texture, rects["left"], 1, true, false, _OFFSET),
		FramesetSetup.new(texture, rects["right"], 1, true, false, _OFFSET)
	))
