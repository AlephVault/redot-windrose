extends Object

## Fixes a sprite to a texture, a region in the texture,
## and ensuring it's treated as static sprite.
static func fix_static_sprite(sprite: Sprite2D, texture: Texture2D, region_rect: Rect2i):
	sprite.texture = texture
	sprite.hframes = 1
	sprite.vframes = 1
	sprite.frame = 0
	sprite.frame_coords = Vector2i.ZERO
	sprite.region_enabled = true
	sprite.region_rect = region_rect
	sprite.region_filter_clip_enabled = true
	sprite.offset = Vector2i(0, -region_rect.size.y)
	sprite.centered = false
	print("Region rect is:", region_rect)
