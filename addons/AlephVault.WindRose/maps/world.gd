extends Node2D
## A world is a place where scopes can be "appointed"
## into, so the world can provide references to them.

const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Exception = _ExceptionUtils.Exception
const _Response = _ExceptionUtils.Response
const _Scope = AlephVault__WindRose.Maps.Scope

var _scopesByKey: Dictionary = {}
var _scopes: Dictionary = {}

# Appoints a scope inside this world, only if the
# scope is not already appointed and the key is not
# in use by another scope.
#
# Only intended to be invoked by the Scope.
func _appoint(scope: _Scope, key: String) -> _Response:
	if scope == null:
		return _Response.fail(_Exception.raise("invalid_scope", "The object to appoint must be a Scope"))
	if _scopes.has(scope):
		return _Response.fail(_Exception.raise("scope_registered", "Scope already registered"))
	if _scopesByKey.has(key):
		return _Response.fail(_Exception.raise("scope_key_occupied", "Scope key already occupied"))
	_scopes[scope] = true
	_scopesByKey[key] = scope
	return _Response.succeed(null)

# Drops a scope by its key.
#
# Only intended to be invoked by the Scope.
func _drop(key: String) -> _Response:
	if not _scopesByKey.has(key):
		return _Response.fail(_Exception.raise("invalid_scope_key", "Unknown or invalid scope key"))
	var scope = _scopesByKey[key]
	_scopesByKey.erase(key)
	_scopes.erase(scope)
	return _Response.succeed(null)

## Gets a scope by a key. If it's an invalid
## or unknown key, it returns none.
func get_scope(key: String) -> _Scope:
	return _scopesByKey.get(key)
