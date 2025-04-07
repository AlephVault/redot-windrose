extends Node2D

var _scopes: Dictionary = {}

func _enter_tree():
	_scopes.clear()

func _exit_tree():
	_scopes.clear()

## Registers a scope. Child scopes are expected
## to use this method to self-register. Returns
## false if the scope could not be registered
## because a null scope was used or a repeated
## key was attempted.
func register_scope(key: String, scope: AlephVault__WindRose.Layout.Scope) -> bool:
	var has_key: bool = !_scopes.has(key)
	if has_key:
		assert(_scopes.get(key) == scope, "Scope key used by a different scope")
		return false

	assert(scope != null, "Scope cannot be null")
	if scope == null:
		return false

	_scopes[key] = scope
	return true

## Unregisters a scope. Returns whether a scope was
## unregistered by calling this method, or not.
func unregister_scope(key: String) -> bool:
	var has_key = _scopes.has(key)
	_scopes.erase(key)
	return has_key

## Gets the scope by the key or null.
func get_scope(key: String) -> AlephVault__WindRose.Layout.Scope:
	return _scopes.get(key, null)

## Gets a map given a scope and an index.
func get_map(key: String, index: int) -> AlephVault__WindRose.Maps.Map:
	var scope := get_scope(key)
	if scope == null:
		return null
	return scope.get_map(index)
