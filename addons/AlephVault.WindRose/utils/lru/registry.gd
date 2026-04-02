extends Object

const _LRUCache = preload("./cache.gd")

static var _caches: Dictionary = {}

static func define(cache_key: String, max_disposal_size: int):
	assert(cache_key != "", "The cache key must not be empty")
	assert(not _caches.has(cache_key), "The cache key is already defined")
	var cache := _LRUCache.new(max_disposal_size)
	_caches[cache_key] = cache
	return cache

static func fetch(cache_key: String):
	assert(cache_key != "", "The cache key must not be empty")
	assert(_caches.has(cache_key), "The cache key is not defined")
	return _caches[cache_key]

static func has(cache_key: String) -> bool:
	return _caches.has(cache_key)

static func undefine(cache_key: String):
	if not _caches.has(cache_key):
		return
	var cache = _caches[cache_key]
	cache.clear()
	_caches.erase(cache_key)

static func clear():
	for cache_key in _caches.keys():
		var cache = _caches[cache_key]
		cache.clear()
	_caches.clear()
