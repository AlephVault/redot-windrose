extends AlephVault__WindRose.Maps.MapEntityTraits
## Base MapEntityTraits schema for REFMAP people visuals.
##
## Trait names intentionally match the visual property names. Concrete
## subclasses extend the property list. Visuals listen to traits_updated
## and apply matching fields themselves.

const _BASE_PROPERTIES: Array[StringName] = [
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
]

func _get_properties() -> Array[StringName]:
	return _BASE_PROPERTIES.duplicate()
