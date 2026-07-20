extends AlephVault__WindRose.Maps.MapEntityTraits
## The MapEntityTraits schema for REFMAP people visuals.
##
## These traits includes aesthetic properties for sex, body, color
## and some objects (hats, necklace, and in-hands).
##
## Also, they can make use of simple or granular (standard) clothing.
## Simple clothes are one entire texture, while granular clothing(s)
## are assembled from individual elements.

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

	# Simple clothes can be used here and will take precedence over
	# any definition of regular clothes (i.e. when they're not null,
	# they're considered on top of any setting for individual parts).
	&"cloth",

	# When no simple clothes are used, clothes' parts are instead used
	# together and assembled into a final texture.
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
	return _BASE_PROPERTIES.duplicate()
