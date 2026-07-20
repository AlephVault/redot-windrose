extends AlephVault__WindRose__REFMAP.Utils.Resolver

const _LRURegistry := AlephVault__WindRose.Utils.LRU.Registry
const _TEXTURE_SIZE := Vector2i(128, 192)

var _resolve_counts: Dictionary = {}

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

static func _valid_texture(texture) -> bool:
	return texture is Texture2D and texture.get_width() == _TEXTURE_SIZE.x and texture.get_height() == _TEXTURE_SIZE.y

func _cache_name() -> String:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"BaseFileSystemResolver", "_cache_name"
	)
	return ""

func _ensure_cache() -> void:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"BaseFileSystemResolver", "_ensure_cache"
	)

func _root_path() -> String:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"BaseFileSystemResolver", "_root_path"
	)
	return ""

func _subcategory(type: String) -> String:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"BaseFileSystemResolver", "_subcategory"
	)
	return ""

func _can_resolve_path(directory: String, path: String) -> bool:
	return true

func _load_texture(path: String):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"BaseFileSystemResolver", "_load_texture"
	)
	return null

## Gets the texture from the shared LRU cache or loads it from
## the concrete resolver's backing storage.
func _cache_get_or_load(path: String):
	_ensure_cache()
	var cache = _LRURegistry.fetch(_cache_name())
	if cache == null:
		return null

	var response = cache.get_value(path, self)
	if response.is_successful() and response.value != null:
		return response.value

	var texture = _load_texture(path)
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
	_LRURegistry.fetch(_cache_name()).delete_value(path, self)

func _component_key(type: String, key: String, color: int) -> String:
	var color_name := _color_string(color)
	return "%s_%s_b" % [key, color_name] if type == HAIR_TAIL else "%s_%s" % [key, color_name]

## Validates the path, resolves it to a texture, and retains the
## matching cache entry while the caller holds the returned texture.
func _resolve_path(directory: String, path: String):
	if not _can_resolve_path(directory, path):
		return null
	var texture = _cache_get_or_load(path)
	if texture != null:
		_retain(path)
	return texture

## Loads component assets from:
## {base_path}/{Sex}/{Subcategory}/{Key}.png
func resolve(sex: Sex, type: String, key: String, color: int = ComponentColor.Default):
	if not is_valid_key(key):
		return null
	var subcategory := _subcategory(type)
	if subcategory == "":
		return null
	var directory := "%s/%s/%s" % [_root_path(), _sex_string(sex), subcategory]
	return _resolve_path(
		directory,
		"%s/%s.png" % [directory, _component_key(type, key, color)]
	)

func unresolve(sex: Sex, type: String, key: String, color: int = ComponentColor.Default):
	if not is_valid_key(key):
		return
	var subcategory := _subcategory(type)
	if subcategory == "":
		return
	var directory := "%s/%s/%s" % [_root_path(), _sex_string(sex), subcategory]
	_release("%s/%s.png" % [directory, _component_key(type, key, color)])

## Loads base body assets from the Base subcategory.
func resolve_body(sex: Sex, color: BodyColor):
	var directory := "%s/%s/Base" % [_root_path(), _sex_string(sex)]
	return _resolve_path(directory, "%s/%s.png" % [directory, _body_color_string(color)])

func unresolve_body(sex: Sex, color: BodyColor):
	var directory := "%s/%s/Base" % [_root_path(), _sex_string(sex)]
	_release("%s/%s.png" % [directory, _body_color_string(color)])
