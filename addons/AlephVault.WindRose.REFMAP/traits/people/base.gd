extends AlephVault__WindRose.Maps.MapEntityTraits
## Base MapEntityTraits schema for REFMAP people visuals.
##
## Trait names intentionally match the visual property names. Concrete
## subclasses select the visual type and extend the property list.

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

func _is_visual(node: Node) -> bool:
	return node is AlephVault__WindRose__REFMAP.Visuals.People.Base

func _get_properties() -> Array[StringName]:
	return _BASE_PROPERTIES.duplicate()

func _apply(
	_current_traits: Dictionary, new_traits: Dictionary, _merged_traits: Dictionary,
	e: AlephVault__WindRose.Maps.MapEntity
):
	var visual = _find_visual(e)
	if visual == null:
		return

	for property in new_traits:
		visual.set(String(property), new_traits[property])

func _find_visual(e: AlephVault__WindRose.Maps.MapEntity):
	if not is_instance_valid(e):
		return null

	var visual = _find_visual_in(e)
	if visual != null:
		return visual

	var visuals_container = e.get("_visuals_container")
	if is_instance_valid(visuals_container):
		return _find_visual_in(visuals_container)

	return null

func _find_visual_in(parent: Node):
	for child in parent.get_children():
		if _is_visual(child):
			return child
	return null
