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

## Cleans the traits. Returns traits only where the keys are valid.
func clean_traits(traits: Dictionary) -> Dictionary:
	var cleaned: Dictionary = {}
	for trait in traits:
		if not (trait is String or trait is StringName):
			continue

		var property: StringName = StringName(trait)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(trait))
			continue

		cleaned[property] = traits[trait]
	return cleaned

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

## Tells whether a traits dictionary contains any of the given properties.
## Meant to be used by developers inside _apply to define custom logic that
## updates based on one or more simultaneous traits, and one of them is
## being uploaded right now. A precondition is that the given dictionary
## is already cleaned / has actually StringName instances.
func has_any(traits: Dictionary, properties: Array[StringName]) -> bool:
	for prop in properties:
		var property: StringName = StringName(prop)
		if not _property_indices.has(property):
			push_warning("Unknown trait property: " + str(prop))
			continue
		
		if traits.has(property):
			return true
	
	return false

## Override this function to affect the entity by detecting
## what fields were updated and working with the merged values.
##
## A non-existing key in the current_traits or merged_traits
## MUST be treated as treating that trait by default.
func _apply(
	current_traits: Dictionary, new_traits: Dictionary, merged_traits: Dictionary,
	e: _MapEntity
):
	pass

## Applies the traits on the object. Returns the merged traits.
func apply(new_traits: Dictionary, e: _MapEntity) -> Dictionary:
	var current_traits: Dictionary = e.traits
	var cleaned_traits: Dictionary = clean_traits(new_traits)
	var merged_traits: Dictionary = current_traits.duplicate()
	update_traits(merged_traits, cleaned_traits)
	_apply(current_traits, cleaned_traits, merged_traits, e)
	return merged_traits
