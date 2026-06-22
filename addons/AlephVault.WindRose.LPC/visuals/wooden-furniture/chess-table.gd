@tool
extends AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base


const _REGION_RECT := Rect2i(64, 608, 32, 32)


func _get_region_rect() -> Rect2i:
	return _REGION_RECT
