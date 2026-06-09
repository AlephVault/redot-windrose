extends AlephVault__WindRose__REFMAP.Traits.People.Simple
## These traits serve for the purpose of showing labels
## on top of a person: name, description and message.
##
## This class, in particular, extends the Simple trait
## for people.
##
## Each of those elements may be either:
## - String: Used to render a string with a default
##   color (set on the visual itself).
## - [String, int|Color]: Used to render a string with
##   a specified color.
##
## The name and description will strip their extra spaces
## and also convert newlines and/or weird spaces to regular
## spaces (and the, apply stripping).

func _get_properties() -> Array[StringName]:
	var properties := super._get_properties()
	properties.append_array([
		&"name",
		&"description",
		&"message",
	])
	return properties
