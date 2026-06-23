@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum BannerColor {
	NONE,
	WHITE,
	YELLOW,
	BLUE,
	RED,
	GREEN,
}

const _SPRITE_SIZE := Vector2i(64, 128)
const _OFFSET := Vector2(-16, -96)
const _BANNER_COLOR_RECTS := {
	BannerColor.NONE: Rect2i(224, 0, 64, 32),
	BannerColor.WHITE: Rect2i(288, 0, 64, 32),
	BannerColor.YELLOW: Rect2i(224, 32, 64, 32),
	BannerColor.BLUE: Rect2i(352, 0, 64, 32),
	BannerColor.RED: Rect2i(352, 32, 64, 32),
	BannerColor.GREEN: Rect2i(288, 32, 64, 32),
}


## The banner color to render.
@export var banner_color: BannerColor = BannerColor.NONE:
	set(value):
		var next_value := clampi(value, 0, BannerColor.size() - 1)
		if banner_color == next_value:
			return
		_release_textures()
		banner_color = next_value
		_setup_sprite()


func _get_texture_context():
	var banner_rect: Rect2i = _BANNER_COLOR_RECTS.get(
		banner_color, _BANNER_COLOR_RECTS[BannerColor.NONE]
	)
	return _make_context(_SPRITE_SIZE, [
		_make_step("banner-post-top", Rect2i(96, 32, 32, 32), Vector2i(16, 0)),
		_make_step("banner-post-banner-" + str(banner_color), banner_rect, Vector2i(0, 32)),
		_make_step("banner-post-bottom", Rect2i(128, 0, 32, 64), Vector2i(16, 64)),
	])


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _SPRITE_SIZE)


func _get_offset() -> Vector2:
	return _OFFSET
