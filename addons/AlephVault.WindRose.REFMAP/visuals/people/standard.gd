@tool
extends "res://addons/AlephVault.WindRose.REFMAP/visuals/people/base.gd"
## REFMAP people visual using the standard layered outfit model.
##
## It uses all shared base components plus boots, pants, shirt,
## chest, waist, arms, long shirt, shoulders, cloak, and the
## boots_over_pants layering flag.

## Boots component. Accepted values are null, a resolver key
## String, or a direct pair [key: String, Texture2D].
var _boots: Variant = null
var boots: Variant:
	get:
		return _boots
	set(value):
		if _same_layer_value(_boots, value):
			return
		_release_texture()
		_release_resolved_layers()
		_boots = value
		_refresh_visual()

## ComponentColor used when boots are resolved by key.
var _boots_color: int = ComponentColor.Black
@export var boots_color: int = ComponentColor.Black:
	get:
		return _boots_color
	set(value):
		if _boots_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_boots_color = value
		_refresh_visual()

## Pants component. Accepted values are null, a resolver key
## String, or a direct pair [key: String, Texture2D].
var _pants: Variant = null
var pants: Variant:
	get:
		return _pants
	set(value):
		if _same_layer_value(_pants, value):
			return
		_release_texture()
		_release_resolved_layers()
		_pants = value
		_refresh_visual()

## ComponentColor used when pants are resolved by key.
var _pants_color: int = ComponentColor.Black
@export var pants_color: int = ComponentColor.Black:
	get:
		return _pants_color
	set(value):
		if _pants_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_pants_color = value
		_refresh_visual()

## Shirt component. Accepted values are null, a resolver key
## String, or a direct pair [key: String, Texture2D].
var _shirt: Variant = null
var shirt: Variant:
	get:
		return _shirt
	set(value):
		if _same_layer_value(_shirt, value):
			return
		_release_texture()
		_release_resolved_layers()
		_shirt = value
		_refresh_visual()

## ComponentColor used when shirt is resolved by key.
var _shirt_color: int = ComponentColor.Black
@export var shirt_color: int = ComponentColor.Black:
	get:
		return _shirt_color
	set(value):
		if _shirt_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_shirt_color = value
		_refresh_visual()

## Chest overlay component. Accepted values are null, a resolver
## key String, or a direct pair [key: String, Texture2D].
var _chest: Variant = null
var chest: Variant:
	get:
		return _chest
	set(value):
		if _same_layer_value(_chest, value):
			return
		_release_texture()
		_release_resolved_layers()
		_chest = value
		_refresh_visual()

## ComponentColor used when chest is resolved by key.
var _chest_color: int = ComponentColor.Black
@export var chest_color: int = ComponentColor.Black:
	get:
		return _chest_color
	set(value):
		if _chest_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_chest_color = value
		_refresh_visual()

## Waist overlay component. Accepted values are null, a resolver
## key String, or a direct pair [key: String, Texture2D].
var _waist: Variant = null
var waist: Variant:
	get:
		return _waist
	set(value):
		if _same_layer_value(_waist, value):
			return
		_release_texture()
		_release_resolved_layers()
		_waist = value
		_refresh_visual()

## ComponentColor used when waist is resolved by key.
var _waist_color: int = ComponentColor.Black
@export var waist_color: int = ComponentColor.Black:
	get:
		return _waist_color
	set(value):
		if _waist_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_waist_color = value
		_refresh_visual()

## Arms overlay component. Accepted values are null, a resolver
## key String, or a direct pair [key: String, Texture2D].
var _arms: Variant = null
var arms: Variant:
	get:
		return _arms
	set(value):
		if _same_layer_value(_arms, value):
			return
		_release_texture()
		_release_resolved_layers()
		_arms = value
		_refresh_visual()

## ComponentColor used when arms are resolved by key.
var _arms_color: int = ComponentColor.Black
@export var arms_color: int = ComponentColor.Black:
	get:
		return _arms_color
	set(value):
		if _arms_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_arms_color = value
		_refresh_visual()

## Long shirt / robe component. Accepted values are null, a
## resolver key String, or a direct pair [key: String, Texture2D].
var _long_shirt: Variant = null
var long_shirt: Variant:
	get:
		return _long_shirt
	set(value):
		if _same_layer_value(_long_shirt, value):
			return
		_release_texture()
		_release_resolved_layers()
		_long_shirt = value
		_refresh_visual()

## ComponentColor used when long_shirt is resolved by key.
var _long_shirt_color: int = ComponentColor.Black
@export var long_shirt_color: int = ComponentColor.Black:
	get:
		return _long_shirt_color
	set(value):
		if _long_shirt_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_long_shirt_color = value
		_refresh_visual()

## Shoulder overlay component. Accepted values are null, a
## resolver key String, or a direct pair [key: String, Texture2D].
var _shoulders: Variant = null
var shoulders: Variant:
	get:
		return _shoulders
	set(value):
		if _same_layer_value(_shoulders, value):
			return
		_release_texture()
		_release_resolved_layers()
		_shoulders = value
		_refresh_visual()

## ComponentColor used when shoulders are resolved by key.
var _shoulders_color: int = ComponentColor.Black
@export var shoulders_color: int = ComponentColor.Black:
	get:
		return _shoulders_color
	set(value):
		if _shoulders_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_shoulders_color = value
		_refresh_visual()

## Cloak component. The bundled default resolver does not provide
## cloak assets, so use a custom resolver or direct pair.
var _cloak: Variant = null
var cloak: Variant:
	get:
		return _cloak
	set(value):
		if _same_layer_value(_cloak, value):
			return
		_release_texture()
		_release_resolved_layers()
		_cloak = value
		_refresh_visual()

## Controls whether boots are layered after pants.
@export var boots_over_pants: bool = true:
	set(value):
		if boots_over_pants == value:
			return
		_release_texture()
		_release_resolved_layers()
		boots_over_pants = value
		_refresh_visual()

func _make_composition_steps() -> Array:
	_release_resolved_layers()
	var steps := []
	var right_hand_layer := _register_layer(_layer(right_hand, _Resolver.RIGHT_HAND))
	var left_hand_layer := _register_layer(_layer(left_hand, _Resolver.LEFT_HAND))
	var hair_tail_layer := _register_layer(_layer(hair_tail, _Resolver.HAIR_TAIL, hair_tail_color))
	var cloak_layer := _register_layer(_layer(cloak, _Resolver.CLOAK))
	var body_layer := _register_layer(_body_layer())
	var boots_layer := _register_layer(_layer(boots, _Resolver.BOOTS, boots_color))
	var pants_layer := _register_layer(_layer(pants, _Resolver.PANTS, pants_color))
	var shirt_layer := _register_layer(_layer(shirt, _Resolver.SHIRT, shirt_color))
	var chest_layer := _register_layer(_layer(chest, _Resolver.CHEST, chest_color))
	var long_shirt_layer := _register_layer(_layer(long_shirt, _Resolver.LONG_SHIRT, long_shirt_color))
	var necklace_layer := _register_layer(_layer(necklace, _Resolver.NECKLACE))
	var shoulders_layer := _register_layer(_layer(shoulders, _Resolver.SHOULDERS, shoulders_color))
	var waist_layer := _register_layer(_layer(waist, _Resolver.WAIST, waist_color))
	var arms_layer := _register_layer(_layer(arms, _Resolver.ARMS, arms_color))
	var hair_layer := _register_layer(_layer(hair, _Resolver.HAIR, hair_color))
	var hat_layer := _register_layer(_layer(hat, _Resolver.HAT, hat_color))
	_append_step(steps, right_hand_layer, _UP_RECT, "up")
	_append_step(steps, left_hand_layer, _LEFT_RIGHT_UP_RECT, "left_right_up")
	_append_step(steps, hair_tail_layer, _DOWN_RECT, "down")
	_append_step(steps, cloak_layer, _DOWN_RECT, "down")
	_append_step(steps, body_layer, _FULL_RECT, "full")
	_append_step(steps, pants_layer if boots_over_pants else boots_layer, _FULL_RECT, "full")
	_append_step(steps, boots_layer if boots_over_pants else pants_layer, _FULL_RECT, "full")
	_append_step(steps, shirt_layer, _FULL_RECT, "full")
	_append_step(steps, chest_layer, _FULL_RECT, "full")
	_append_step(steps, long_shirt_layer, _FULL_RECT, "full")
	_append_step(steps, necklace_layer, _FULL_RECT, "full")
	_append_step(steps, shoulders_layer, _FULL_RECT, "full")
	_append_step(steps, waist_layer, _FULL_RECT, "full")
	_append_step(steps, arms_layer, _FULL_RECT, "full")
	_append_step(steps, right_hand_layer, _LEFT_RIGHT_RECT, "left_right")
	_append_step(steps, cloak_layer, _LEFT_RIGHT_UP_RECT, "left_right_up")
	_append_step(steps, hair_tail_layer, _LEFT_RIGHT_UP_RECT, "left_right_up")
	_append_step(steps, hair_layer, _FULL_RECT, "full")
	_append_step(steps, hat_layer, _FULL_RECT, "full")
	_append_step(steps, left_hand_layer, _DOWN_RECT, "down")
	_append_step(steps, right_hand_layer, _DOWN_RECT, "down")
	return steps
