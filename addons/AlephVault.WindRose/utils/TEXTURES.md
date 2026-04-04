# Texture Utilities

This directory provides a texture composition API under `AlephVault__WindRose.Utils.Textures`.

It is built around two classes:

- `Step`: Defines one source texture region and where it must be blended in the final image.
- `Context`: Defines the target texture size, the ordered steps to apply, and the cache integration.

## `Step`

Construct a step with:

```gdscript
var step = AlephVault__WindRose.Utils.Textures.Step.new(
	"body",
	texture,
	Rect2i(Vector2i(0, 0), Vector2i(32, 32)),
	Vector2i(16, 16)
)
```

A step validates:

- The key is not empty.
- The texture is not null.
- The source rect starts at a non-negative position.
- The source rect size is strictly positive.
- The source rect is fully contained in the source texture.
- The target position is non-negative.
- The texture image data is available and uses `Image.FORMAT_RGBA8`.

Relevant read-only properties:

- `key`
- `texture`
- `source_rect`
- `target_position`
- `target_rect`
- `invalid`

Public method:

- `blend_into(target_image: Image)`
  Alpha-blends the step source rect into the target image at the configured target position.

## `Context`

Construct a context with:

```gdscript
var context = AlephVault__WindRose.Utils.Textures.Context.new(
	64,
	64,
	[step_a, step_b]
)
```

A context validates:

- Width and height are strictly positive.
- The steps array is not null.
- Every item is a `Step`.
- Every step is valid.
- Every step target rect fits inside the final texture bounds.

Relevant read-only properties:

- `width`
- `height`
- `steps`
- `final_key`
- `invalid`

The `final_key` is derived by joining each step key in order with `:`.

## Cache Integration

`Context` is designed to work with `AlephVault__WindRose.Utils.LRU.Registry`.

Public methods:

- `get_texture(obj, cache_key: String) -> Texture2D`
  Fetches the texture from the named LRU cache, or builds and stores it if it is missing.
- `dispose(obj, cache_key: String)`
  Releases `obj` as a reference holder for this composed texture in the named cache.

Before calling `get_texture` or `dispose`, define the cache in the LRU registry:

```gdscript
AlephVault__WindRose.Utils.LRU.Registry.define("portraits", 32)
```

## Typical Usage

```gdscript
AlephVault__WindRose.Utils.LRU.Registry.define("portraits", 32)

var body = AlephVault__WindRose.Utils.Textures.Step.new(
	"body",
	body_texture,
	Rect2i(Vector2i.ZERO, Vector2i(32, 32)),
	Vector2i(0, 0)
)

var hat = AlephVault__WindRose.Utils.Textures.Step.new(
	"hat",
	hat_texture,
	Rect2i(Vector2i.ZERO, Vector2i(32, 32)),
	Vector2i(0, 0)
)

var context = AlephVault__WindRose.Utils.Textures.Context.new(32, 32, [body, hat])
var texture = context.get_texture(self, "portraits")

# Later, when this object no longer needs the texture:
context.dispose(self, "portraits")
```

The object passed to `get_texture` and `dispose` must be a valid live `Object`, because the underlying LRU cache
tracks references through that owner.
