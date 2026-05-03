@tool
extends AlephVault__WindRose__LPC.Visuals.Farm.WaterWheel


const _WATER_WHEEL_HALF_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-water-wheel-half.png")


func _setup_sprite() -> void:
    centered = false
    offset = Vector2(-48, 0)
	texture = _WATER_WHEEL_HALF_TEXTURE
	region_enabled = true
	region_filter_clip_enabled = true
	region_rect = Rect2(Vector2.ZERO, Vector2(64, 256))
	hframes = 1
	vframes = 4
	_vertically_distributed = true
	_region_rect_up = Rect2()
	_region_rect_left = Rect2()
	_region_rect_right = Rect2()
