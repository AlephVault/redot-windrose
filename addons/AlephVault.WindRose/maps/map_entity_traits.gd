extends RefCounted

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _MapEntity = AlephVault__WindRose.Maps.MapEntity

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
	
	for trait_ in traits:
		if not (trait_ is String or trait_ is StringName):
			return _Response.fail(
				_Exception.raise(
					"invalid_trait_property",
					"Trait property must be a String or StringName"
				)
			)
		
		var property: StringName = StringName(trait_)
		if not _property_indices.has(property):
			return _Response.fail(
				_Exception.raise(
					"unknown_trait_property",
					"Unknown trait property: " + str(trait_)
				)
			)
		
		var idx: int = _property_indices[property]
		values_by_index[idx] = traits[trait_]
	
	var serialized: Array = []
	for idx in range(_properties.size()):
		if values_by_index.has(idx):
			serialized.append([idx, values_by_index[idx]])
	
	return _Response.succeed(serialized)

## De-serializes an array as a dictionary.
func deserialize(traits: Array) -> _Response:
	var deserialized: Dictionary = {}
	var used_indices: Dictionary = {}
	
	for trait_ in traits:
		if trait_.size() != 2:
			return _Response.fail(
				_Exception.raise(
					"invalid_trait_entry",
					"Serialized trait entries must have exactly two items"
				)
			)
		
		var idx = trait_[0]
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
		deserialized[_properties[idx]] = trait_[1]
	
	return _Response.succeed(deserialized)

## Cleans the traits. Returns traits only where the keys are valid.
func clean_traits(traits: Dictionary) -> Dictionary:
	var cleaned: Dictionary = {}
	for trait_ in traits:
		if not (trait_ is String or trait_ is StringName):
			continue

		var property: StringName = StringName(trait_)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(trait_))
			continue

		cleaned[property] = traits[trait_]
	return cleaned

## Updates the current traits dictionary in-place with valid schema properties.
func update_traits(current: Dictionary, updated: Dictionary) -> void:
	for trait_ in updated:
		if not (trait_ is String or trait_ is StringName):
			continue
		
		var property: StringName = StringName(trait_)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(trait_))
			continue
		
		current.erase(String(property))
		current.erase(property)
		current[property] = updated[trait_]

## Tells whether a traits dictionary contains any of the given properties.
## Useful in traits_updated listeners to define custom logic that updates
## based on one or more simultaneous traits. A precondition is that the
## given dictionary is already cleaned / has actually StringName instances.
func has_any(traits: Dictionary, properties: Array[StringName]) -> bool:
	for prop in properties:
		var property: StringName = StringName(prop)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(prop))
			continue
		
		if traits.has(property):
			return true
	
	return false

## Applies the traits on the object. Returns the merged traits and the
## normalized traits that were applied. Visuals and other side effects
## must react to MapEntity.traits_updated to be aware of these changes.
func apply(new_traits: Dictionary, e: _MapEntity) -> Array[Dictionary]:
	var current_traits: Dictionary = e.traits
	var cleaned_traits: Dictionary = clean_traits(new_traits)
	var merged_traits: Dictionary = current_traits.duplicate()
	update_traits(merged_traits, cleaned_traits)
	return [merged_traits, cleaned_traits]
