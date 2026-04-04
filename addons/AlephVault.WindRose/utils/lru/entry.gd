extends Object
## A cache entry accounts for a specific value and
## all the references that track this entry. Also,
## whether this element is queued for disposal or
## not (instead: being an active entry).
##
## The entry also has a mean to have its value
## disposed.

var _value
var _references: Dictionary = {}
var queued: bool = false
var _disposed: bool = false
var _dispose: Callable

static func NOOP():
	pass

## Returns the current value for this entry.
var value:
	get:
		return _value
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entry", "value"
		)

## Returns whether this entry is disposed or not.
var disposed: bool:
	get:
		return _disposed
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entry", "disposed"
		)

## Returns the dict of references.
var references: Dictionary:
	get:
		return _references
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Entry", "references"
		)

func _init(value, dispose: Callable = NOOP):
	_value = value
	_dispose = dispose

## Disposes the current entry.
func dispose():
	if not _disposed:
		_dispose.call()
		_disposed = true

## Prunes all the references that belong to objects
## that are not valid references anymore (i.e. were
## deleted long time ago). This updates the dict of
## references, removing stale ones.
func prune_references():
	var stale_ids: Array[int] = []
	for object_id in references.keys():
		var object_ref: WeakRef = references[object_id]
		if object_ref == null or object_ref.get_ref() == null:
			stale_ids.push_back(object_id)
	for object_id in stale_ids:
		references.erase(object_id)

## Returns the count of references (prunes them first)
## to this entry.
func reference_count() -> int:
	prune_references()
	return references.size()

## Adds a reference to this entry.
func add_reference(obj: Object):
	references[obj.get_instance_id()] = weakref(obj)

## Removes a reference from this entry.
func remove_reference(obj: Object):
	references.erase(obj.get_instance_id())
