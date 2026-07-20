extends AlephVault__WindRose__REFMAP.Utils.BaseFileSystemResolver

## Bundled resolver for imported REFMAP assets under the addon images directory.
## It supports the historical DefaultResolver component subset and uses load()
## so Godot reads the imported Texture2D resources.

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

## Ensures the configured LRU cache exists and locks the static
## cache settings. After the first ensure, changing either static
## cache setting is a usage error.
func _ensure_cache() -> void:
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

func _cache_name() -> String:
	return _locked_texture_cache_name

func _root_path() -> String:
	return _BASE_PATH

func _subcategory(type: String) -> String:
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

func _load_texture(path: String):
	return load(path)
