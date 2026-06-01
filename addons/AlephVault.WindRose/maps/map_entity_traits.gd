extends RefCounted

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response

# Cached indices by property.
var _property_indices: Dictionary = {}

# Cached properties by index.
var _properties: Array[StringName] = []

## Defines the properties for this schema.
func _get_properties() -> Array[StringName]:
	return []

func _init():
	var props: Array[StringName] = _get_properties()
	for prop in props:
		if not (prop is String or prop is StringName):
			push_warning("Property '" + str(prop) + "' is not a String or StringName")
			continue
		
		var prop_: StringName = StringName(prop)
		if _property_indices.has(prop_):
			push_warning("Property '" + str(prop) + "' already defined")
		else:
			var idx: int = _property_indices.size()
			_property_indices[prop_] = idx
			_properties.append(prop_)

## Serializes a dictionary as an array.
func serialize(traits: Dictionary) -> _Response:
	var values_by_index: Dictionary = {}
	
	for trait in traits:
		if not (trait is String or trait is StringName):
			return _Response.fail(
				_Exception.raise(
					"invalid_trait_property",
					"Trait property must be a String or StringName"
				)
			)
		
		var property: StringName = StringName(trait)
		if not _property_indices.has(property):
			return _Response.fail(
				_Exception.raise(
					"unknown_trait_property",
					"Unknown trait property: " + str(trait)
				)
			)
		
		var idx: int = _property_indices[property]
		values_by_index[idx] = traits[trait]
	
	var serialized: Array[Array] = []
	for idx in range(_properties.size()):
		if values_by_index.has(idx):
			serialized.append([idx, values_by_index[idx]])
	
	return _Response.succeed(serialized)

## De-serializes an array as a dictionary.
func deserialize(traits: Array[Array]) -> _Response:
	var deserialized: Dictionary = {}
	var used_indices: Dictionary = {}
	
	for trait in traits:
		if trait.size() != 2:
			return _Response.fail(
				_Exception.raise(
					"invalid_trait_entry",
					"Serialized trait entries must have exactly two items"
				)
			)
		
		var idx = trait[0]
		if not (idx is int):
			return _Response.fail(
				_Exception.raise(
					"invalid_trait_index",
					"Serialized trait index must be an int"
				)
			)
		
		if idx < 0 or idx >= _properties.size():
			return _Response.fail(
				_Exception.raise(
					"unknown_trait_index",
					"Unknown trait index: " + str(idx)
				)
			)
		
		if used_indices.has(idx):
			return _Response.fail(
				_Exception.raise(
					"duplicated_trait_index",
					"Duplicated trait index: " + str(idx)
				)
			)
		
		used_indices[idx] = true
		deserialized[_properties[idx]] = trait[1]
	
	return _Response.succeed(deserialized)

## Updates the current traits dictionary in-place with valid schema properties.
func update_traits(current: Dictionary, updated: Dictionary) -> void:
	for trait in updated:
		if not (trait is String or trait is StringName):
			continue
		
		var property: StringName = StringName(trait)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(trait))
			continue
		
		current.erase(String(property))
		current.erase(property)
		current[property] = updated[trait]
