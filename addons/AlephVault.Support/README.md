# Support / Common Features and Utilities

General utilities are described in this package.

## API

The package entrypoint is [index.gd](/home/luis/Projects/AlephVault/redot-windrose/addons/AlephVault.Textures/index.gd).

It exposes four main types:

- `AlephVault__Textures.Step`
- `AlephVault__Textures.Context`
- `AlephVault__Textures.LRUCache`
- `AlephVault__Textures.CacheRegistry`

## Cache lifecycle

Define one or more named caches before requesting textures:

```gdscript
AlephVault__Textures.CacheRegistry.define("my-cache", 64)
```

The integer value is the maximum size of the disposal queue. When a
texture loses all references, it moves to that queue. If the queue grows
beyond its configured size, the oldest queued textures are evicted from
the cache.

## Composition steps

Each step describes:

- A unique string key.
- A source `Texture2D`.
- A source `Rect2i` inside the source texture.
- A target `Vector2i` position in the final texture.

The target rectangle is inferred from the target position plus the source
rectangle size.

All source textures must expose `Image.FORMAT_RGBA8` image data. Step
validation also requires:

- Non-empty keys.
- Non-negative source positions.
- Strictly positive source sizes.
- Source rectangles fully contained in the source texture.
- Non-negative target positions.

Example:

```gdscript
var body_step = AlephVault__Textures.Step.new(
	"body-base",
	body_texture,
	Rect2i(0, 0, 64, 64),
	Vector2i(0, 0)
)

var shirt_step = AlephVault__Textures.Step.new(
	"male-shirt-1-red",
	shirt_texture,
	Rect2i(32, 0, 64, 64),
	Vector2i(0, 0)
)
```

## Contexts

Contexts are built dynamically and validate that every step fits inside
the final texture bounds:

```gdscript
var context = AlephVault__Textures.Context.new(
	64,
	64,
	[body_step, shirt_step]
)
```

The final cache key is the `:`-joined list of the step keys, in order.

## Getting and releasing textures

Requesting a texture:

```gdscript
var texture: Texture2D = context.get(self, "my-cache")
```

If the key is already cached, the existing texture is returned and `self`
is registered as a reference. Otherwise the texture is composed, cached,
and then returned.

Releasing a texture:

```gdscript
context.dispose(self, "my-cache")
```

If `self` was not registered as an active reference for that composed
texture, disposal is a no-op. The cache key must still exist.

## Notes

- The package currently validates textures from actual `Texture2D`
  instances. It does not yet implement header-only metadata loading for
  deferred validation.
- Compositing uses `Image.blend_rect`, so source alpha is respected while
  layering the steps.
- Users should not manually dispose cached textures. They should release
  them through `context.dispose(obj, cache_key)`.
