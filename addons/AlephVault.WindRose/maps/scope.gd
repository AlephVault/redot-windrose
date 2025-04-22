extends Node2D

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _World = AlephVault__WindRose.Maps.World
const _Map = AlephVault__WindRose.Maps.Map

var _key: String = ""
var _world: _World = null
var _maps: Dictionary = {}

## The scope key, when attached to a world.
var key: String:
	get:
		return _key
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Scope", "key"
		)

## The world instance, when attached to a world.
var world: _World:
	get:
		return _world
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Scope", "world"
		)

## Registers the scope in a world using a proper key.
func appoint(world: _World, key: String) -> _Response:
	if _world != null:
		return _Response.fail(_Exception.raise("already_appointed", "Already appointed to a world"))
	if world == null:
		return _Response.fail(_Exception.raise("invalid_world", "The world cannot be null"))
	key = key.strip_edges()
	if key == "":
		return _Response.fail(_Exception.raise("invalid_key", "The key cannot be empty"))
	var response: _Response = world._appoint(self, key)
	if response.is_successful():
		_world = world
		_key = key
	return response

## Drops from the currently attached world.
func drop() -> _Response:
	if _world == null:
		return _Response.fail(_Exception.raise("not_appointed", "Not appointed to a world"))
	_world._drop(key)
	key = ""
	_world = null
	return _Response.succeed(null)

## Registers a map into the scope. This is typically
## done statically by the map. A map being added will
## never be deleted.
func _add_map(map: _Map, index: int) -> _Response:
	if map == null:
		return _Response.fail(_Exception.raise("invalid_map", "The map cannot be null"))
	_maps[index] = map
	return _Response.succeed(null)

## Gets a map by its index, or null.
func get_map(index: int) -> _Map:
	return _maps.get(index)

func _exit_tree() -> void:
	if _world != null:
		drop()
