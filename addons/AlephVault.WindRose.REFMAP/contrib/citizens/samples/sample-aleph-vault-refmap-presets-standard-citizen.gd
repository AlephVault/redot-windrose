extends AlephVault__WindRose.Contrib.Simple.MapEntity
## Sample entity exposing StandardCitizen traits for the preset visual example.

const _PeopleVisual = AlephVault__WindRose__REFMAP.Visuals.People.Base
const _StandardCitizenTraits = AlephVault__WindRose__REFMAP.Contrib.Citizens.Traits.Standard

static var _traits_schema := _StandardCitizenTraits.new()

func _ready() -> void:
	_ensure_resolver()
	super._ready()
	_apply_initial_traits()

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema

func _ensure_resolver() -> void:
	var people = AlephVault__WindRose__REFMAP.Visuals.People
	if people.Base.resolver == null or not is_instance_valid(people.Base.resolver):
		people.Base.resolver = AlephVault__WindRose__REFMAP.Utils.DefaultResolver.new()

func _apply_initial_traits() -> void:
	traits = {
		&"sex": _PeopleVisual.Sex.Female,
		&"body": _PeopleVisual.BodyColor.White,
		&"hair": "7",
		&"hair_color": _PeopleVisual.ComponentColor.DarkBrown,
		&"shirt": "2",
		&"shirt_color": _PeopleVisual.ComponentColor.Blue,
		&"pants": "1",
		&"pants_color": _PeopleVisual.ComponentColor.Black,
		&"boots": "1",
		&"boots_color": _PeopleVisual.ComponentColor.DarkBrown,
		&"name": ["  Mira   Ashford  ", 0x808080ff],
		&"description": "  Standard   citizen   preset  ",
		&"message": ["  Hello,   traveler!\n\n\nThis    message keeps at most two blank lines.  ", Color.WHITE],
	}
