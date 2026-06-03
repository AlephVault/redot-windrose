extends AlephVault__WindRose__REFMAP.Traits.People.Base
## MapEntityTraits schema for REFMAP standard people visuals.

const _STANDARD_PROPERTIES: Array[StringName] = [
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

func _get_properties() -> Array[StringName]:
	var properties := super._get_properties()
	properties.append_array(_STANDARD_PROPERTIES)
	return properties
