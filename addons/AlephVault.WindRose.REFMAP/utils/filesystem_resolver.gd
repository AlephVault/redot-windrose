extends AlephVault__WindRose__REFMAP.Utils.BaseFileSystemResolver

## Resolver for runtime PNG assets stored under a persistent user:// directory.
## Unlike DefaultResolver, it supports every Resolver component type and loads
## raw PNG files without requiring Godot import metadata.

var _texture_cache_name: String
var _texture_cache_max_disposal_size: int
var _base_path: String

## LRU cache key used by this resolver for source REFMAP textures.
## This value is configured at construction time and is read-only.
var texture_cache_name: String:
	get:
		return _texture_cache_name
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"FileSystemResolver", "texture_cache_name"
		)

## Maximum disposal queue size for this resolver cache.
## This value is configured at construction time and is read-only.
var texture_cache_max_disposal_size: int:
	get:
		return _texture_cache_max_disposal_size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"FileSystemResolver", "texture_cache_max_disposal_size"
		)

## Root user:// directory containing {Sex}/{Subcategory}/{Key}.png files.
## This value is configured at construction time and is read-only.
var base_path: String:
	get:
		return _base_path
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"FileSystemResolver", "base_path"
		)

func _init(root_directory: String, cache_name: String, cache_max_disposal_size: int):
	_texture_cache_name = cache_name.strip_edges()
	_texture_cache_max_disposal_size = cache_max_disposal_size
	_base_path = _normalize_base_path(root_directory)

	assert(_texture_cache_name != "", "The REFMAP filesystem resolver texture cache name must not be empty")
	assert(_texture_cache_max_disposal_size >= 0, "The REFMAP filesystem resolver texture cache disposal size must be non-negative")

static func _normalize_base_path(path: String) -> String:
	var normalized := path.strip_edges()
	while normalized.ends_with("/") and normalized != "user://":
		normalized = normalized.trim_suffix("/")
	return normalized

func _ensure_cache() -> void:
	if _LRURegistry.has(_texture_cache_name):
		var cache = _LRURegistry.fetch(_texture_cache_name)
		assert(cache.max_disposal_size == _texture_cache_max_disposal_size, "The REFMAP filesystem resolver texture cache disposal size must match the existing cache")
	else:
		_LRURegistry.define(_texture_cache_name, _texture_cache_max_disposal_size)

func _cache_name() -> String:
	return _texture_cache_name

func _root_path() -> String:
	return _base_path

func _subcategory(type: String) -> String:
	match type:
		ARMS:
			return "Arms"
		BOOTS:
			return "Boots"
		CHEST:
			return "Chest"
		CLOAK:
			return "Cloak"
		CLOTH:
			return "Cloth"
		HAIR, HAIR_TAIL:
			return "Hair"
		HAT:
			return "Hat"
		LEFT_HAND:
			return "LeftHand"
		LONG_SHIRT:
			return "LongShirt"
		NECKLACE:
			return "Necklace"
		PANTS:
			return "Pants"
		RIGHT_HAND:
			return "RightHand"
		SHIRT:
			return "Shirt"
		SHOULDERS:
			return "Shoulder"
		WAIST:
			return "Waist"
		_:
			return ""

func _valid_base_path() -> bool:
	return _base_path.begins_with("user://") and DirAccess.dir_exists_absolute(_base_path)

func _can_resolve_path(directory: String, path: String) -> bool:
	return _valid_base_path() and DirAccess.dir_exists_absolute(directory) and FileAccess.file_exists(path)

func _load_texture(path: String):
	var image := Image.new()
	if image.load(path) != OK:
		return null

	return ImageTexture.create_from_image(image)
