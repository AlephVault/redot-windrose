extends Node2D
## A Map is the functional unit of space for
## these games. It contains several layers,
## being the entities layer the most important
## one sine it holds the entities.

const _Scope = AlephVault__WindRose.Maps.Scope
const _World = AlephVault__WindRose.Maps.World

## Use an index >= 0 (unique!) to register this
## map in its parent scope.
@export var _index: int = -1
var _scope: _Scope

## Gets the current scope, if any.
var scope: _Scope:
	get:
		return _scope
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Map", "scope"
		)

func _enter_tree() -> void:
	var parent = get_parent()
	if parent is _Scope and _index >= 0 and _scope == null:
		var _result = parent._add_map(self, _index)
		if _result.is_successful():
			_scope = parent

## Gets another map from the same world.
## Returns null if there's no world or
## the parameters are invalid.
func get_world_map(key: String, index: int) -> AlephVault__WindRose.Maps.Map:
	if _scope == null:
		return null
	var world: _World = scope.world
	if world == null:
		return null
	return world.get_map(key, index)

## Gets another map from the same scope.
## Returns null if there's no scope or
## the parameters are invalid.
func get_scope_map(index: int) -> AlephVault__WindRose.Maps.Map:
	if _scope == null:
		return null
	return _scope.get_map(index)
