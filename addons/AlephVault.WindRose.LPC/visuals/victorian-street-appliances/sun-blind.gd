@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum SunBlindColor {
	COLOR_WHITE,
	COLOR_YELLOW,
	COLOR_LITEBLUE,
	COLOR_RED,
	COLOR_GREEN,
	COLOR_BROWN,
}

const _LEVEL_OFFSET := -32
const _BASE_LEVELS := 2
const _REGION_RECTS := [
	Rect2i(512, 224, 96, 96),
	Rect2i(640, 224, 96, 96),
	Rect2i(512, 320, 96, 96),
	Rect2i(640, 320, 96, 96),
	Rect2i(512, 416, 96, 96),
	Rect2i(640, 416, 96, 96),
]


## The sun blind color to render.
@export var color: SunBlindColor = SunBlindColor.COLOR_WHITE:
	set(value):
		var next_value := clampi(value, 0, SunBlindColor.size() - 1)
		if color == next_value:
			return
		color = next_value
		_setup_sprite()


## The sun blind extension level to render.
@export var level: int = 0:
	set(value):
		var next_value := maxi(0, value)
		if level == next_value:
			return
		level = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(color), 0, SunBlindColor.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return Vector2(0, (_BASE_LEVELS + level) * _LEVEL_OFFSET)
