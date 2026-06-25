@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base


enum CartType {
	CART_WOODEN1,
	CART_WOODEN2,
	CART_WOODEN3,
	CART_WOODEN4,
}

const _OFFSET := Vector2(0, -32)
const _REGION_RECTS := [
	Rect2i(736, 64, 64, 64),
	Rect2i(800, 64, 64, 64),
	Rect2i(864, 64, 64, 64),
	Rect2i(928, 64, 64, 64),
]


## The cart visual variant.
@export var cart_type: CartType = CartType.CART_WOODEN1:
	set(value):
		var next_value := clampi(value, 0, CartType.size() - 1)
		if cart_type == next_value:
			return
		cart_type = next_value
		_setup_sprite()


func _get_key() -> int:
	return clampi(int(cart_type), 0, CartType.size() - 1)


func _get_region_rect() -> Rect2i:
	return _REGION_RECTS[_get_key()]


func _get_offset() -> Vector2:
	return _OFFSET
