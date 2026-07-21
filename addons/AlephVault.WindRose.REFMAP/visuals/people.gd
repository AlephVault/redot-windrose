@tool
extends AlephVault__WindRose.Maps.Visuals.MovableMapEntityVisual
## Class for REFMAP people visuals.
##
## The final sprite sheet is 128x192, arranged as four rows of
## 32x48 frames: down, left, right, and up. This class allows the
## definition of people using simple clothing or standard (assembled)
## clothing, as defined in the corresponding traits.

const _Resolver := preload("../utils/resolver.gd")
const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context
const _LRURegistry := AlephVault__WindRose.Utils.LRU.Registry

const _TEXTURE_SIZE := Vector2i(128, 192)
const _FRAME_SIZE := Vector2i(32, 48)
const _FULL_RECT := Rect2i(Vector2i.ZERO, _TEXTURE_SIZE)
const _DOWN_RECT := Rect2i(0, 0, 128, 48)
const _DOWN_FRAME_RECT := Rect2i(0, 0, 32, 48)
const _LEFT_RIGHT_RECT := Rect2i(0, 48, 128, 96)
const _LEFT_FRAME_RECT := Rect2i(0, 48, 32, 48)
const _RIGHT_FRAME_RECT := Rect2i(0, 96, 32, 48)
const _LEFT_RIGHT_UP_RECT := Rect2i(0, 48, 128, 144)
const _UP_RECT := Rect2i(0, 144, 128, 48)
const _UP_FRAME_RECT := Rect2i(0, 144, 32, 48)
const _SPRITE_OFFSET := Vector2(0, -_FRAME_SIZE.y + _FRAME_SIZE.x)
const _DEFAULT_CACHE_NAME := "refmap_people"
const _DEFAULT_CACHE_MAX_DISPOSAL_SIZE := 256
const _TEXTURE_REFRESH_DEBOUNCE_SECONDS := 0.05
const _TEXTURE_BUILD_STEPS_PER_FRAME := 8
const _TRAIT_PROPERTIES: Array[StringName] = [
	&"sex",
	&"body",
	&"hair",
	&"hair_color",
	&"hair_tail",
	&"hair_tail_color",
	&"necklace",
	&"hat",
	&"hat_color",
	&"right_hand",
	&"left_hand",

	# Simple clothes can be used here and will take precedence over
	# any definition of regular clothes (i.e. when they're not null,
	# they're considered on top of any setting for individual parts).
	&"cloth",

	# When no simple clothes are used, clothes' parts are instead used
	# together and assembled into a final texture.
	&"boots",
	&"boots_color",
	&"pants",
	&"pants_color",
	&"shirt",
	&"shirt_color",
	&"chest",
	&"chest_color",
	&"waist",
	&"waist_color",
	&"arms",
	&"arms_color",
	&"long_shirt",
	&"long_shirt_color",
	&"shoulders",
	&"shoulders_color",
	&"cloak",
	&"boots_over_pants",
]

enum Sex {
	Male,
	Female,
}

enum ComponentColor {
	Default = 0,
	Black = 0,
	Blue,
	DarkBrown,
	Green,
	LightBrown,
	Pink,
	Purple,
	Red,
	White,
	Yellow,
}

enum BodyColor {
	Default = 0,
	White = 0,
	Black,
	Yellow,
	Orange,
	Blue,
	Red,
	Green,
	Purple,
}

## Internal record for a component texture that may need a later
## unresolve call. Direct [key, Texture2D] pairs are not unresolved.
class ResolvedLayer:
	var key: String
	var texture: Texture2D
	var via_resolver: bool
	var is_body: bool
	var sex: Sex
	var type: String
	var color: int
	var body_color: int

	func _init(
		layer_key: String,
		layer_texture: Texture2D,
		layer_via_resolver: bool,
		layer_is_body: bool,
		layer_sex: Sex,
		layer_type: String,
		layer_color: int,
		layer_body_color: int
	):
		key = layer_key
		texture = layer_texture
		via_resolver = layer_via_resolver
		is_body = layer_is_body
		sex = layer_sex
		type = layer_type
		color = layer_color
		body_color = layer_body_color

## Resolver used when a component value is a String key.
## Assign an instance of Resolver or DefaultResolver. Direct
## [key, Texture2D] component pairs do not use this resolver.
static var resolver = null

## LRU cache key used for composed final character textures.
## Set this during application startup, before the first REFMAP
## people visual refreshes.
static var texture_cache_name: String = _DEFAULT_CACHE_NAME

## Maximum disposal queue size for composed final character
## textures. Set this during application startup, before the
## first REFMAP people visual refreshes.
static var texture_cache_max_disposal_size: int = _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
static var _cache_ensured: bool = false
static var _locked_texture_cache_name: String = ""
static var _locked_texture_cache_max_disposal_size: int = 0

## The sex of the character.
@export var sex: Sex = Sex.Male:
	set(value):
		if sex == value:
			return
		_release_texture()
		_release_resolved_layers()
		sex = value
		_refresh_visual()

## Body component. Accepted values are null, a BodyColor value,
## or a direct pair [key: String, texture: Texture2D].
var _body: Variant = BodyColor.White
var body: Variant:
	get:
		return _body
	set(value):
		if _same_layer_value(_body, value):
			return
		_release_texture()
		_release_resolved_layers()
		_body = value
		_refresh_visual()

## Front hair component. Accepted values are null, a resolver
## key String, or a direct pair [key: String, texture: Texture2D].
var _hair: Variant = null
var hair: Variant:
	get:
		return _hair
	set(value):
		if _same_layer_value(_hair, value):
			return
		_release_texture()
		_release_resolved_layers()
		_hair = value
		_refresh_visual()

## ComponentColor used when hair is resolved by key.
var _hair_color: int = ComponentColor.Black
@export var hair_color: int = ComponentColor.Black:
	get:
		return _hair_color
	set(value):
		if _hair_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_hair_color = value
		_refresh_visual()

## Back/tail hair component. Accepted values are null, a resolver
## key String, or a direct pair [key: String, texture: Texture2D].
var _hair_tail: Variant = null
var hair_tail: Variant:
	get:
		return _hair_tail
	set(value):
		if _same_layer_value(_hair_tail, value):
			return
		_release_texture()
		_release_resolved_layers()
		_hair_tail = value
		_refresh_visual()

## ComponentColor used when hair_tail is resolved by key.
var _hair_tail_color: int = ComponentColor.Black
@export var hair_tail_color: int = ComponentColor.Black:
	get:
		return _hair_tail_color
	set(value):
		if _hair_tail_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_hair_tail_color = value
		_refresh_visual()

## Necklace component. The bundled default resolver does not
## provide necklace assets, so use a custom resolver or direct pair.
var _necklace: Variant = null
var necklace: Variant:
	get:
		return _necklace
	set(value):
		if _same_layer_value(_necklace, value):
			return
		_release_texture()
		_release_resolved_layers()
		_necklace = value
		_refresh_visual()

## Hat component. Accepted values are null, a resolver key String,
## or a direct pair [key: String, texture: Texture2D].
var _hat: Variant = null
var hat: Variant:
	get:
		return _hat
	set(value):
		if _same_layer_value(_hat, value):
			return
		_release_texture()
		_release_resolved_layers()
		_hat = value
		_refresh_visual()

## ComponentColor used when hat is resolved by key.
var _hat_color: int = ComponentColor.Black
@export var hat_color: int = ComponentColor.Black:
	get:
		return _hat_color
	set(value):
		if _hat_color == value:
			return
		_release_texture()
		_release_resolved_layers()
		_hat_color = value
		_refresh_visual()

## Right-hand item component. The bundled default resolver does
## not provide hand item assets, so use a custom resolver or
## direct pair.
var _right_hand: Variant = null
var right_hand: Variant:
	get:
		return _right_hand
	set(value):
		if _same_layer_value(_right_hand, value):
			return
		_release_texture()
		_release_resolved_layers()
		_right_hand = value
		_refresh_visual()

## Left-hand item component. The bundled default resolver does
## not provide hand item assets, so use a custom resolver or
## direct pair.
var _left_hand: Variant = null
var left_hand: Variant:
	get:
		return _left_hand
	set(value):
		if _same_layer_value(_left_hand, value):
			return
		_release_texture()
		_release_resolved_layers()
		_left_hand = value
		_refresh_visual()

## Complete clothing component. Accepted values are null, a
## resolver key String, or a direct pair [key: String, Texture2D].
## The bundled default resolver does not provide cloth assets.
##
## If the cloth is set (i.e. not null), then a single cloth will
## be used, and the properties describing clothes' parts (e.g.
## chest, shirt, boots, ...) are ignored.
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

# Cloth parts' properties start here. They're considered only if
# the `cloth property` is not set.

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

# These are common stuff / implementation.

var _texture_context = null
var _resolved_layers: Array[ResolvedLayer] = []
var _texture_refresh_generation: int = 0
var _traits_entity: AlephVault__WindRose.Maps.MapEntity = null

## Ensures the composed-texture LRU cache exists and locks the
## static cache settings. After the first ensure, changing either
## static cache setting is a usage error.
static func _ensure_cache() -> void:
	var cache_name := texture_cache_name.strip_edges()
	assert(cache_name != "", "The REFMAP people texture cache name must not be empty")
	assert(texture_cache_max_disposal_size >= 0, "The REFMAP people texture cache disposal size must be non-negative")
	if _cache_ensured:
		assert(cache_name == _locked_texture_cache_name, "The REFMAP people texture cache name cannot change after the cache is ensured")
		assert(texture_cache_max_disposal_size == _locked_texture_cache_max_disposal_size, "The REFMAP people texture cache disposal size cannot change after the cache is ensured")
	else:
		_locked_texture_cache_name = cache_name
		_locked_texture_cache_max_disposal_size = texture_cache_max_disposal_size
		_cache_ensured = true
	if not _LRURegistry.has(_locked_texture_cache_name):
		_LRURegistry.define(_locked_texture_cache_name, _locked_texture_cache_max_disposal_size)

func _init() -> void:
	_configure_sprite()

func _ready() -> void:
	_refresh_visual()

func _setup():
	_connect_traits()
	if is_instance_valid(map_entity):
		_apply_traits(map_entity.traits)
	_refresh_visual()
	super._setup()

func _teardown():
	_disconnect_traits()
	super._teardown()
	_release_texture()
	_release_resolved_layers()

func _validate_property(property: Dictionary) -> void:
	if property.name in [
		"texture",
		"centered",
		"offset",
		"hframes",
		"vframes",
		"frame",
		"frame_coords",
		"region_enabled",
		"region_rect",
		"region_filter_clip_enabled",
		"_vertically_distributed",
		"_region_rect_up",
		"_region_rect_left",
		"_region_rect_right",
	]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _same_layer_value(a, b) -> bool:
	if a is Array and b is Array:
		if a.size() != b.size():
			return false
		for index in range(a.size()):
			if a[index] != b[index]:
				return false
		return true
	return a == b

func _get_traits_properties() -> Array[StringName]:
	return _TRAIT_PROPERTIES.duplicate()

func _connect_traits() -> void:
	if not is_instance_valid(map_entity):
		return
	_traits_entity = map_entity
	if not _traits_entity.traits_updated.is_connected(_on_traits_updated):
		_traits_entity.traits_updated.connect(_on_traits_updated)

func _disconnect_traits() -> void:
	if not is_instance_valid(_traits_entity):
		_traits_entity = null
		return
	if _traits_entity.traits_updated.is_connected(_on_traits_updated):
		_traits_entity.traits_updated.disconnect(_on_traits_updated)
	_traits_entity = null

func _on_traits_updated(new_traits: Dictionary) -> void:
	_apply_traits(new_traits)

func _apply_traits(new_traits: Dictionary) -> void:
	if not is_instance_valid(_traits_entity):
		return
	var schema = _traits_entity.get_traits_schema()
	if schema == null:
		return
	var properties := _get_traits_properties()
	if not schema.has_any(new_traits, properties):
		return
	for property in properties:
		if new_traits.has(property):
			set(String(property), new_traits[property])

func _valid_texture(value) -> bool:
	return value is Texture2D and value.get_width() == _TEXTURE_SIZE.x and value.get_height() == _TEXTURE_SIZE.y

## Direct component values must be [key, texture]. The key becomes
## part of the composed texture cache key, so it follows the same
## no-space/no-colon rule as resolver keys.
func _valid_pair(value) -> bool:
	return value is Array and value.size() == 2 and value[0] is String and _Resolver.is_valid_key(value[0]) and _valid_texture(value[1])

func _resolver() -> Object:
	return resolver if resolver != null and is_instance_valid(resolver) else null

func _resolve_body_layer(value) -> ResolvedLayer:
	if value == null:
		return null
	if _valid_pair(value):
		return ResolvedLayer.new("body:direct:%s" % value[0], value[1], false, true, sex, "", 0, 0)
	if not (value is int):
		return null
	var resolver_obj := _resolver()
	if resolver_obj == null:
		return null
	var body_color := int(value)
	var texture = resolver_obj.resolve_body(sex, body_color)
	if not _valid_texture(texture):
		if texture != null:
			resolver_obj.unresolve_body(sex, body_color)
		return null
	return ResolvedLayer.new("body:%s:%d" % [str(sex), body_color], texture, true, true, sex, "", 0, body_color)

func _resolve_component_layer(type: String, value, color: int = ComponentColor.Default) -> ResolvedLayer:
	if value == null:
		return null
	if _valid_pair(value):
		return ResolvedLayer.new("%s:direct:%s" % [type, value[0]], value[1], false, false, sex, type, color, 0)
	if not (value is String):
		return null
	var key: String = value.strip_edges()
	if not _Resolver.is_valid_key(key):
		return null
	var resolver_obj := _resolver()
	if resolver_obj == null:
		return null
	var texture = resolver_obj.resolve(sex, type, key, color)
	if not _valid_texture(texture):
		if texture != null:
			resolver_obj.unresolve(sex, type, key, color)
		return null
	return ResolvedLayer.new("%s:%s:%s:%d" % [type, str(sex), key, color], texture, true, false, sex, type, color, 0)

func _layer(value: Variant, type: String, color: int = ComponentColor.Default) -> ResolvedLayer:
	return _resolve_component_layer(type, value, color)

func _body_layer() -> ResolvedLayer:
	return _resolve_body_layer(body)

func _append_step(steps: Array, layer: ResolvedLayer, source_rect: Rect2i, suffix: String) -> void:
	if layer == null:
		return
	steps.append(_Step.new("%s:%s" % [layer.key, suffix], layer.texture, source_rect, source_rect.position))

func _make_simple_composition_steps() -> Array:
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

func _make_standard_composition_steps() -> Array:
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

func _make_composition_steps() -> Array:
	_release_resolved_layers()
	var steps := []
	if cloth == null:
		return _make_standard_composition_steps()
	else:
		return _make_simple_composition_steps()

func _build_context():
	var steps := _make_composition_steps()
	return _Context.new(_TEXTURE_SIZE.x, _TEXTURE_SIZE.y, steps)

## Releases this visual's reference to the currently composed
## texture. The LRU cache may keep the texture alive for reuse.
func _release_texture() -> void:
	_texture_refresh_generation += 1
	if _texture_context != null and _cache_ensured:
		_texture_context.dispose_texture(self, _locked_texture_cache_name)
	_texture_context = null

func _release_resolved_layers() -> void:
	var resolver_obj := _resolver()
	if resolver_obj != null:
		for layer in _resolved_layers:
			if not layer.via_resolver:
				continue
			if layer.is_body:
				resolver_obj.unresolve_body(layer.sex, layer.body_color)
			else:
				resolver_obj.unresolve(layer.sex, layer.type, layer.key.split(":")[2], layer.color)
	_resolved_layers.clear()

func _register_layer(layer: ResolvedLayer) -> ResolvedLayer:
	if layer != null:
		_resolved_layers.append(layer)
	return layer

## Configures Sprite2D and MovableMapEntityVisual details for
## the fixed REFMAP 4-direction, 4-frame sheet layout.
func _configure_sprite() -> void:
	_vertically_distributed = false
	hframes = 4
	vframes = 1
	region_enabled = true
	region_filter_clip_enabled = true
	region_rect = _DOWN_RECT
	_region_rect_left = _LEFT_RIGHT_RECT
	_region_rect_right = Rect2i(0, 96, 128, 48)
	_region_rect_up = _UP_RECT
	centered = false
	offset = _SPRITE_OFFSET

func _make_full_setup() -> FullSetup:
	var down := FramesetSetup.new(texture, _DOWN_FRAME_RECT, 1, false, false, _SPRITE_OFFSET)
	var up := FramesetSetup.new(texture, _UP_FRAME_RECT, 1, false, false, _SPRITE_OFFSET)
	var left := FramesetSetup.new(texture, _LEFT_FRAME_RECT, 1, false, false, _SPRITE_OFFSET)
	var right := FramesetSetup.new(texture, _RIGHT_FRAME_RECT, 1, false, false, _SPRITE_OFFSET)
	var moving_down := FramesetSetup.new(texture, _DOWN_RECT, 4, false, false, _SPRITE_OFFSET)
	var moving_up := FramesetSetup.new(texture, _UP_RECT, 4, false, false, _SPRITE_OFFSET)
	var moving_left := FramesetSetup.new(texture, Rect2i(0, 48, 128, 48), 4, false, false, _SPRITE_OFFSET)
	var moving_right := FramesetSetup.new(texture, Rect2i(0, 96, 128, 48), 4, false, false, _SPRITE_OFFSET)
	return FullSetup.new(
		StateSetup.new(down, up, left, right),
		{
			AlephVault__WindRose.Maps.MapEntity.STATE_MOVING: StateSetup.new(
				moving_down, moving_up, moving_left, moving_right
			)
		}
	)

func _refresh_visual() -> void:
	_texture_refresh_generation += 1
	var generation := _texture_refresh_generation
	if is_inside_tree():
		_refresh_visual_debounced(generation)
	else:
		_refresh_visual_now(generation, false)


func _refresh_visual_debounced(generation: int) -> void:
	await get_tree().create_timer(_TEXTURE_REFRESH_DEBOUNCE_SECONDS).timeout
	if generation != _texture_refresh_generation:
		return
	await _refresh_visual_now(generation, true)


func _refresh_visual_now(generation: int, chunked: bool) -> void:
	_ensure_cache()
	var next_context = _build_context()
	if next_context.invalid:
		return
	if generation != _texture_refresh_generation:
		return
	var previous_context = _texture_context
	var next_texture: Texture2D
	if chunked:
		next_texture = await next_context.get_texture_chunked(
			self, _locked_texture_cache_name, _TEXTURE_BUILD_STEPS_PER_FRAME
		)
	else:
		next_texture = next_context.get_texture(self, _locked_texture_cache_name)
	if generation != _texture_refresh_generation:
		return
	if previous_context != null and previous_context.final_key != next_context.final_key:
		previous_context.dispose_texture(self, _locked_texture_cache_name)
	_texture_context = next_context
	texture = next_texture
	_configure_sprite()
	if is_instance_valid(full_setup):
		full_setup.default_state.set_image(next_texture)
		var moving_setup = full_setup.get_state(AlephVault__WindRose.Maps.MapEntity.STATE_MOVING)
		if moving_setup != full_setup.default_state:
			moving_setup.set_image(next_texture)
		_apply()
	centered = false
	offset = _SPRITE_OFFSET
