extends "res://addons/AlephVault.WindRose.REFMAP/traits/people/base.gd"
## MapEntityTraits schema for REFMAP simple people visuals.

const _SIMPLE_PROPERTIES: Array[StringName] = [
	&"cloth",
]

func _is_visual(node: Node) -> bool:
	return node is AlephVault__WindRose__REFMAP.Visuals.People.Simple

func _get_properties() -> Array[StringName]:
	var properties := super._get_properties()
	properties.append_array(_SIMPLE_PROPERTIES)
	return properties
