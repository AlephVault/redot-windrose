extends Node2D
## A MapLayer is a special object which serves
## as one of the layers inside a map, tells its
## z-index (and fixes it), and provides specific
## functionality (e.g. managing entities).

var _map: AlephVault__WindRose.Maps.Map

## The current map for this layer. It's
## inferred from the parent object on
## initialization.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _map
	set(value):
		assert(false, "The map cannot be set this way")

func _ready():
	var _parent = get_parent()
	if _parent is AlephVault__WindRose.Maps.Map:
		_map = _parent
	request_ready()

func _z_index() -> int:
	return 10

func _enter_tree():
	if not (get_parent() is AlephVault__WindRose.Maps.Map):
		push_warning("A MapLayer was added into a tree to a non-Map parent")
	else:
		var z = self._z_index()
		if z < 0:
			z = 0
		self.z_index = z

func _exit_tree():
	_map = null
