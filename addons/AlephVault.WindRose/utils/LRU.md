# LRU Utilities

This directory provides a small reference-counted LRU cache API under `AlephVault__WindRose.Utils.LRU`.

## Main Classes

- `Entry`: Internal cache entry that stores the cached value, its weak references, and an optional disposal callback.
- `Cache`: The actual cache implementation.
- `Registry`: A global registry of named caches.

## Cache Behavior

Each cache entry is tracked by:

- A string key.
- A stored value.
- Zero or more referencing `Object` instances, held through `WeakRef`.
- An optional dispose callback.

Entries are not discarded immediately when the last reference is removed. Instead, they are moved into a disposal queue.
When that queue grows past `max_disposal_size`, the oldest queued entries are disposed and removed permanently, as long
as they still have no active references.

If an entry is requested again before it is evicted from that queue, it is rescued and becomes active again.

## `Cache`

Construct a cache with:

```gdscript
var cache = AlephVault__WindRose.Utils.LRU.Cache.new(10)
```

Public methods:

- `get_value(entry_key: String, obj) -> Response`
  Returns the cached value for `entry_key`, or `null` if it is missing. The `obj` argument must be a valid `Object`
  and becomes a reference holder for that entry.
- `set_value(entry_key: String, value, dispose, obj) -> Response`
  Creates or reuses an entry, associates it to `obj`, and returns the stored value. If `dispose` is `null`, a no-op
  disposer is used.
- `delete_value(entry_key: String, obj) -> Response`
  Removes `obj` as a reference holder for that entry. If the entry ends up without references, it is queued for
  later disposal.
- `has_value(entry_key: String) -> bool`
  Returns whether the entry currently exists in the cache, including entries still waiting in the disposal queue.
- `clear()`
  Disposes every stored entry and clears the cache immediately.

All `get_value`, `set_value`, and `delete_value` operations validate `obj`. If it is not a valid live `Object`,
they return a failed `AlephVault__WindRose.Utils.ExceptionUtils.Response`.

## `Registry`

The registry stores caches by string key:

```gdscript
var cache = AlephVault__WindRose.Utils.LRU.Registry.define("portraits", 32)
```

Public methods:

- `define(cache_key: String, max_disposal_size: int)`
  Creates and stores a cache under `cache_key`.
- `fetch(cache_key: String)`
  Returns the cache previously defined for that key.
- `has(cache_key: String) -> bool`
  Tells whether a cache exists for that key.
- `undefine(cache_key: String)`
  Clears and removes one cache.
- `clear()`
  Clears and removes all registered caches.

## Typical Usage

```gdscript
var registry = AlephVault__WindRose.Utils.LRU.Registry
registry.define("example", 8)

var cache = registry.fetch("example")
var owner = Node.new()

var created = cache.set_value("grass", {"kind": "grass"}, null, owner)
if created.is_successful():
	print(created.value)

var fetched = cache.get_value("grass", owner)
if fetched.is_successful():
	print(fetched.value)

cache.delete_value("grass", owner)
```
