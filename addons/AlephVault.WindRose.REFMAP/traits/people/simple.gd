extends AlephVault__WindRose__REFMAP.Traits.People.Base
## MapEntityTraits schema for REFMAP simple people visuals.

const _SIMPLE_PROPERTIES: Array[StringName] = [
	&"cloth",
]

func _get_properties() -> Array[StringName]:
	var properties := super._get_properties()
	properties.append_array(_SIMPLE_PROPERTIES)
	return properties
