extends "res://addons/AlephVault.WindRose.REFMAP/utils/resolver.gd"

const _LRURegistry := AlephVault__WindRose.Utils.LRU.Registry
const _TEXTURE_SIZE := Vector2i(128, 192)
const _DEFAULT_CACHE_NAME := "refmap_textures"
const _DEFAULT_CACHE_MAX_DISPOSAL_SIZE := 256
const _BASE_PATH := "res://addons/AlephVault.WindRose.REFMAP/images"

## LRU cache key used by the bundled resolver for source
## REFMAP textures. Set this during application startup,
## before the first resolve/unresolve call.
static var texture_cache_name: String = _DEFAULT_CACHE_NAME

## Maximum disposal queue size for the bundled resolver cache.
## Set this during application startup, before the first
## resolve/unresolve call.
static var texture_cache_max_disposal_size: int = _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
static var _cache_ensured: bool = false
static var _locked_texture_cache_name: String = ""
static var _locked_texture_cache_max_disposal_size: int = 0

var _resolve_counts: Dictionary = {}

## Ensures the configured LRU cache exists and locks the static
## cache settings. After the first ensure, changing either static
## cache setting is a usage error.
static func _ensure_cache() -> void:
	var cache_name := texture_cache_name.strip_edges()
	assert(cache_name != "", "The REFMAP default resolver texture cache name must not be empty")
	assert(texture_cache_max_disposal_size >= 0, "The REFMAP default resolver texture cache disposal size must be non-negative")
	if _cache_ensured:
		assert(cache_name == _locked_texture_cache_name, "The REFMAP default resolver texture cache name cannot change after the cache is ensured")
		assert(texture_cache_max_disposal_size == _locked_texture_cache_max_disposal_size, "The REFMAP default resolver texture cache disposal size cannot change after the cache is ensured")
	else:
		_locked_texture_cache_name = cache_name
		_locked_texture_cache_max_disposal_size = texture_cache_max_disposal_size
		_cache_ensured = true
	if not _LRURegistry.has(_locked_texture_cache_name):
		_LRURegistry.define(_locked_texture_cache_name, _locked_texture_cache_max_disposal_size)

static func _sex_string(sex: Sex) -> String:
	return "Male" if sex == Sex.Male else "Female"

static func _color_string(color: int) -> String:
	match color:
		ComponentColor.Blue:
			return "blue"
		ComponentColor.DarkBrown:
			return "dbrown"
		ComponentColor.Green:
			return "green"
		ComponentColor.LightBrown:
			return "lbrown"
		ComponentColor.Pink:
			return "pink"
		ComponentColor.Purple:
			return "purple"
		ComponentColor.Red:
			return "red"
		ComponentColor.White:
			return "white"
		ComponentColor.Yellow:
			return "yellow"
		_:
			return "black"

static func _body_color_string(color: BodyColor) -> String:
	match color:
		BodyColor.Black:
			return "Black_e"
		BodyColor.Yellow:
			return "Yellow_e"
		BodyColor.Orange:
			return "Orange_e"
		BodyColor.Blue:
			return "Blue_e"
		BodyColor.Red:
			return "Red_e"
		BodyColor.Green:
			return "Green_e"
		BodyColor.Purple:
			return "Purple_e"
		_:
			return "White_e"

static func _subcategory(type: String) -> String:
	match type:
		ARMS:
			return "Arms"
		BOOTS:
			return "Boots"
		CHEST:
			return "Chest"
		HAIR, HAIR_TAIL:
			return "Hair"
		HAT:
			return "Hat"
		LONG_SHIRT:
			return "LongShirt"
		SHIRT:
			return "Shirt"
		SHOULDERS:
			return "Shoulder"
		WAIST:
			return "Waist"
		PANTS:
			return "Pants"
		_:
			return ""

static func _valid_texture(texture) -> bool:
	return texture is Texture2D and texture.get_width() == _TEXTURE_SIZE.x and texture.get_height() == _TEXTURE_SIZE.y

func _cache_get_or_load(path: String):
	_ensure_cache()
	var cache = _LRURegistry.fetch(_locked_texture_cache_name)
	var response = cache.get_value(path, self)
	if response.is_successful() and response.value != null:
		return response.value
	var texture = load(path)
	if not _valid_texture(texture):
		return null
	return cache.set_value(path, texture, null, self).value

func _retain(path: String) -> void:
	_resolve_counts[path] = int(_resolve_counts.get(path, 0)) + 1

func _release(path: String) -> void:
	if not _resolve_counts.has(path):
		return
	var count := int(_resolve_counts[path]) - 1
	if count > 0:
		_resolve_counts[path] = count
		return
	_resolve_counts.erase(path)
	_ensure_cache()
	_LRURegistry.fetch(_locked_texture_cache_name).delete_value(path, self)

func _resolve_path(path: String):
	var texture = _cache_get_or_load(path)
	if texture != null:
		_retain(path)
	return texture

## Loads bundled component assets from:
## res://addons/AlephVault.WindRose.REFMAP/images/{Sex}/{Subcategory}/{Key}.png
##
## Unsupported bundled types return null: right_hand, left_hand,
## cloth, necklace, and cloak.
func resolve(sex: Sex, type: String, key: String, color: int = ComponentColor.Default):
	if not is_valid_key(key):
		return null
	var subcategory := _subcategory(type)
	if subcategory == "":
		return null
	var color_name := _color_string(color)
	var resolved_key := "%s_%s_b" % [key, color_name] if type == HAIR_TAIL else "%s_%s" % [key, color_name]
	return _resolve_path("%s/%s/%s/%s.png" % [_BASE_PATH, _sex_string(sex), subcategory, resolved_key])

func unresolve(sex: Sex, type: String, key: String, color: int = ComponentColor.Default):
	if not is_valid_key(key):
		return
	var subcategory := _subcategory(type)
	if subcategory == "":
		return
	var color_name := _color_string(color)
	var resolved_key := "%s_%s_b" % [key, color_name] if type == HAIR_TAIL else "%s_%s" % [key, color_name]
	_release("%s/%s/%s/%s.png" % [_BASE_PATH, _sex_string(sex), subcategory, resolved_key])

## Loads bundled base body assets from the Base subcategory.
func resolve_body(sex: Sex, color: BodyColor):
	return _resolve_path("%s/%s/Base/%s.png" % [_BASE_PATH, _sex_string(sex), _body_color_string(color)])

func unresolve_body(sex: Sex, color: BodyColor):
	_release("%s/%s/Base/%s.png" % [_BASE_PATH, _sex_string(sex), _body_color_string(color)])
