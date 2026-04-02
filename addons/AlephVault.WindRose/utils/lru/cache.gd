extends Object
## An LRU cache structure manages cached elements with the
## possibility to get + register new elements, or unget
## elements.
##
## Getting and ungetting elements keeps also tracks of who
## is getting / ungetting them. When an element is completely
## unget, THAT element is moved to the disposal queue. That
## queue has a maximum size, so if the size grows bigger
## than the specified size, older elements are definitely
## disposed and can never be rescued again (they need to
## be created / registered like the first time). Meanwhile,
## getting an element that was in the dispose queue allows
## the element to being rescued (back in the active cache)
## and remains as if it was registered the first time, and
## no disposal / re-creating process occurs there.

const Entry = preload("./entry.gd")
const _ExceptionUtils = AlephVault__WindRose.Utils.ExceptionUtils
const _Response = _ExceptionUtils.Response
const _Exception = _ExceptionUtils.Exception

var _max_disposal_size: int
var _entries: Dictionary = {}
var _disposal_queue: Array[String] = []

## Returns the maximum size of the disposal queue. When this
## queue has more elements than the amount in this property,
## the oldest elements are deleted completely (and, in the
## worst case, need to be re-created from scratch).
var max_disposal_size: int:
	get:
		return _max_disposal_size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Cache", "max_disposal_size"
		)

func _init(disposal_queue_size: int = 10):
	if disposal_queue_size >= 0:
		_max_disposal_size = disposal_queue_size
	else:
		_max_disposal_size = 10

func _require_object(obj) -> _Response:
	var is_obj = obj is Object and obj != null and is_instance_valid(obj)
	if is_obj:
		return _Response.succeed(null)
	return _Response.fail(
		_Exception.raise("not_object", "The reference must be a valid object")
	)

func _dequeue(entry_key: String, entry: Entry):
	if not entry.queued:
		return
	var index: int = _disposal_queue.find(entry_key)
	if index != -1:
		_disposal_queue.remove_at(index)
	entry.queued = false

func _trim_queue():
	while _disposal_queue.size() > _max_disposal_size:
		var evicted_key: String = _disposal_queue.pop_front()
		var entry: Entry = _entries.get(evicted_key, null)
		if entry == null:
			continue
		entry.prune_references()
		if entry.references.is_empty():
			entry.dispose()
			_entries.erase(evicted_key)
		else:
			entry.queued = false

## Gets an entry from the cache. If the entry is missing,
## getting the entry returns null. Otherwise, it returns
## the entry's value and also associates the entry to
## the object in the second argument, tying the reference.
func get(entry_key: String, obj) -> _Response:
	var response: _Response = _require_object(obj)
	if not response.is_successful():
		return response
	var entry: Entry = _entries.get(entry_key, null)
	if entry == null:
		return _Response.succeed(null)
	entry.prune_references()
	_dequeue(entry_key, entry)
	entry.add_reference(obj)
	return _Response.succeed(entry.value)

## Initializes the value as a new entry in the cache.
## The value is specified and a dispose function is
## given as well (on null, the dispose is a noop).
## It also associates it to the object acting as a
## reference / requester.
func set(entry_key: String, value, dispose, obj) -> _Response:
	var response: _Response = _require_object(obj)
	if not response.is_successful():
		return response
	if dispose == null:
		dispose = Entry.NOOP
	var entry: Entry = _entries.get(entry_key, null)
	if entry == null:
		entry = Entry.new(value, dispose)
		_entries[entry_key] = entry
	else:
		_dequeue(entry_key, entry)
	entry.add_reference(obj)
	return _Response.succeed(entry.value)

## Deletes a reference for an entry. Once the reference
## is removed, it evaluates the possibility to send it
## to the LRU disposal queue. It also prunes the queue.
func delete(entry_key: String, obj) -> _Response:
	var response: _Response = _require_object(obj)
	if not response.is_successful():
		return response
	var entry: Entry = _entries.get(entry_key, null)
	if entry == null:
		return _Response.succeed(false)
	entry.prune_references()
	entry.remove_reference(obj)
	if entry.reference_count() == 0 and not entry.queued:
		entry.queued = true
		_disposal_queue.push_back(entry_key)
	_trim_queue()
	return _Response.succeed(true)

## Tells whether the cache has this element. This includes
## elements that are in the LRU disposal queue.
func has(entry_key: String) -> bool:
	return _entries.has(entry_key)

func clear():
	for entry_key in _entries.keys():
		var entry: Entry = _entries[entry_key]
		entry.dispose()
	_entries.clear()
	_disposal_queue.clear()
