@tool
extends "res://addons/AlephVault.WindRose.REFMAP/visuals/people/base.gd"
## REFMAP people visual using the simple clothing model.
##
## It uses all shared base components plus one complete cloth
## overlay. Components are composed in the order documented in
## the package README, with partial hand/hair-tail rows layered
## around the body and clothing.

## Complete clothing component. Accepted values are null, a
## resolver key String, or a direct pair [key: String, Texture2D].
## The bundled default resolver does not provide cloth assets.
var _cloth: Variant = null
var cloth: Variant:
	get:
		return _cloth
	set(value):
		if _same_layer_value(_cloth, value):
			return
		_release_texture()
		_release_resolved_layers()
		_cloth = value
		_refresh_visual()

func _make_composition_steps() -> Array:
	_release_resolved_layers()
	var steps := []
	var right_hand_layer := _register_layer(_layer(right_hand, _Resolver.RIGHT_HAND))
	var left_hand_layer := _register_layer(_layer(left_hand, _Resolver.LEFT_HAND))
	var hair_tail_layer := _register_layer(_layer(hair_tail, _Resolver.HAIR_TAIL, hair_tail_color))
	var body_layer := _register_layer(_body_layer())
	var cloth_layer := _register_layer(_layer(cloth, _Resolver.CLOTH))
	var necklace_layer := _register_layer(_layer(necklace, _Resolver.NECKLACE))
	var hair_layer := _register_layer(_layer(hair, _Resolver.HAIR, hair_color))
	var hat_layer := _register_layer(_layer(hat, _Resolver.HAT, hat_color))
	_append_step(steps, right_hand_layer, _UP_RECT, "up")
	_append_step(steps, left_hand_layer, _LEFT_RIGHT_UP_RECT, "left_right_up")
	_append_step(steps, hair_tail_layer, _DOWN_RECT, "down")
	_append_step(steps, body_layer, _FULL_RECT, "full")
	_append_step(steps, cloth_layer, _FULL_RECT, "full")
	_append_step(steps, necklace_layer, _FULL_RECT, "full")
	_append_step(steps, hair_layer, _FULL_RECT, "full")
	_append_step(steps, right_hand_layer, _LEFT_RIGHT_RECT, "left_right")
	_append_step(steps, hair_tail_layer, _LEFT_RIGHT_UP_RECT, "left_right_up")
	_append_step(steps, hat_layer, _FULL_RECT, "full")
	_append_step(steps, left_hand_layer, _DOWN_RECT, "down")
	_append_step(steps, right_hand_layer, _DOWN_RECT, "down")
	return steps
