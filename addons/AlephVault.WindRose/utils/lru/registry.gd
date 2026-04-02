extends Object
## A global registry of named LRU caches. Each cache is
## created once by key and can later be fetched, queried,
## undefined, or fully cleared.

const _LRUCache = preload("./cache.gd")

static var _caches: Dictionary = {}

## Defines a new cache under the given key and returns it.
## The key must be non-empty and not already registered.
static func define(cache_key: String, max_disposal_size: int):
	assert(cache_key != "", "The cache key must not be empty")
	assert(not _caches.has(cache_key), "The cache key is already defined")
	var cache := _LRUCache.new(max_disposal_size)
	_caches[cache_key] = cache
	return cache

## Fetches a previously defined cache by key.
## In debug builds, missing or empty keys assert.
## In non-debug builds, an unknown key yields null.
static func fetch(cache_key: String):
	assert(cache_key != "", "The cache key must not be empty")
	var has_cache = _caches.has(cache_key)
	assert(has_cache, "The cache key is not defined")
	if not has_cache:
		return null
	return _caches[cache_key]

## Tells whether a cache is currently defined for the key.
static func has(cache_key: String) -> bool:
	return _caches.has(cache_key)

## Clears and removes a single named cache.
## If the key is unknown, this is a no-op.
static func undefine(cache_key: String):
	if not _caches.has(cache_key):
		return
	var cache = _caches[cache_key]
	cache.clear()
	_caches.erase(cache_key)

## Clears every registered cache and removes all entries
## from the registry itself.
static func clear():
	for cache_key in _caches.keys():
		var cache = _caches[cache_key]
		cache.clear()
	_caches.clear()
