extends Node2D

## The scope key, to be used in a world.
@export var _key: String = ""

## The scope key, to be used in a world.
var key: String:
	get:
		return _key
	set(value):
		if _key == "":
			_key = value
		else:
			assert(false, "The key cannot be changed")

var _maps: Array = []

func _enter_tree():
	_maps.clear()
	for child in get_children():
		if child is AlephVault__WindRose.Maps.Map:
			_maps.append(child)

func _exit_tree():
	_maps.clear()

## Returns one of the maps.
func get_map(index: int) -> AlephVault__WindRose.Maps.Map:
	if index < 0 or index >= _maps.size():
		return null
	return _maps[index]
