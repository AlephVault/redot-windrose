extends Node2D

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
