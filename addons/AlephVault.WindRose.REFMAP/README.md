# WindRose.REFMAP

This package contains REFMAP-related features: ability to create sprites for 128x192 images depicting frames for 32x48
characters (4 directions, and 4 frames per direction).

Usage
-----

REFMAP people visuals build a final animated character sheet by composing 128x192 component textures. The expected layout is:

```text
DDDD
LLLL
RRRR
UUUU
```

Each row has four 32x48 frames. Rows are, in order: down-facing, left-facing, right-facing, and up-facing. The composed result is used by a movable WindRose visual, so idle state uses frame 0 and moving state animates the four frames at the visual's `fps`.

### Public Classes

- `AlephVault__WindRose__REFMAP.Utils.Resolver`: Interface for resolving component keys into textures.
- `AlephVault__WindRose__REFMAP.Utils.DefaultResolver`: Bundled LRU-backed resolver for assets under `addons/AlephVault.WindRose.REFMAP/images`.
- `AlephVault__WindRose__REFMAP.Visuals.People.Base`: Shared abstract parent for people visuals. Do not instantiate this directly.
- `AlephVault__WindRose__REFMAP.Visuals.People.Simple`: People visual using one complete `cloth` layer.
- `AlephVault__WindRose__REFMAP.Visuals.People.Standard`: People visual using separate outfit layers.
- `AlephVault__WindRose__REFMAP.Traits.People.Base`: Shared `MapEntityTraits` schema for people visuals.
- `AlephVault__WindRose__REFMAP.Traits.People.Simple`: Traits schema for simple people visuals.
- `AlephVault__WindRose__REFMAP.Traits.People.Standard`: Traits schema for standard people visuals.

### Resolver Setup

String component values require a resolver. Assign one early in your game startup:

```gdscript
var resolver := AlephVault__WindRose__REFMAP.Utils.DefaultResolver.new()
AlephVault__WindRose__REFMAP.Visuals.People.Base.resolver = resolver
```

The resolver cache settings are static and must be configured before the first resolve:

```gdscript
AlephVault__WindRose__REFMAP.Utils.DefaultResolver.texture_cache_name = "refmap_source_textures"
AlephVault__WindRose__REFMAP.Utils.DefaultResolver.texture_cache_max_disposal_size = 256
```

The composed people texture cache settings are also static and must be configured before the first people visual refresh:

```gdscript
AlephVault__WindRose__REFMAP.Visuals.People.Base.texture_cache_name = "refmap_people"
AlephVault__WindRose__REFMAP.Visuals.People.Base.texture_cache_max_disposal_size = 256
```

After either cache is first ensured, changing its static settings is a usage error.

### Component Values

Each component is optional. Set it to `null` to omit it.

Components accept either:

- a resolver key `String`, such as `"1"`;
- a direct pair `[key, texture]`, where `key` is a unique string and `texture` is a 128x192 `Texture2D`.

Resolver keys and direct pair keys must be non-empty and cannot contain spaces or `:`.

Direct pairs do not call the resolver and are not unresolved later. String keys are resolved through `Base.resolver`; if the resolver returns `null`, a non-`Texture2D`, or a texture that is not 128x192, that layer is omitted.

### Enums

`Sex`:

- `Male`
- `Female`

`ComponentColor` for hair/equipment/clothing. This is named `ComponentColor` in code to avoid colliding with Redot's built-in `Color` type:

- `Default` / `Black`
- `Blue`
- `DarkBrown`
- `Green`
- `LightBrown`
- `Pink`
- `Purple`
- `Red`
- `White`
- `Yellow`

`BodyColor`:

- `Default` / `White`
- `Black`
- `Yellow`
- `Orange`
- `Blue`
- `Red`
- `Green`
- `Purple`

### Simple People Visual

The simple visual is implemented by `AlephVault__WindRose__REFMAP.Visuals.People.Simple`.

Shared properties:

- `sex`: Selects male or female assets.
- `body`: `null`, a `BodyColor`, or a direct `[key, Texture2D]` pair.
- `hair`, `hair_color`: Front hair component and color.
- `hair_tail`, `hair_tail_color`: Long back/tail hair component and color.
- `necklace`: Necklace overlay. The bundled default resolver does not provide this asset type.
- `hat`, `hat_color`: Hat component and color.
- `right_hand`: Right-hand item. The bundled default resolver does not provide this asset type.
- `left_hand`: Left-hand item. The bundled default resolver does not provide this asset type.
- `fps`: Moving animation frames per second, inherited from the WindRose movable visual.

Simple-only property:

- `cloth`: Complete clothing overlay. The bundled default resolver does not provide this asset type.

Composition order:

1. Right hand, up row only.
2. Left hand, left/right/up rows.
3. Hair tail, down row only.
4. Body, full texture.
5. Cloth, full texture.
6. Necklace, full texture.
7. Hair, full texture.
8. Right hand, left/right rows.
9. Hair tail, left/right/up rows.
10. Hat, full texture.
11. Left hand, down row only.
12. Right hand, down row only.

### Standard People Visual

The standard visual is implemented by `AlephVault__WindRose__REFMAP.Visuals.People.Standard`.

It has all shared properties from the simple visual, except `cloth`, and adds:

- `boots`, `boots_color`
- `pants`, `pants_color`
- `shirt`, `shirt_color`
- `chest`, `chest_color`
- `waist`, `waist_color`
- `arms`, `arms_color`
- `long_shirt`, `long_shirt_color`
- `shoulders`, `shoulders_color`
- `cloak`: The bundled default resolver does not provide this asset type.
- `boots_over_pants`: If `true`, pants are composed before boots. If `false`, boots are composed before pants.

Composition order:

1. Right hand, up row only.
2. Left hand, left/right/up rows.
3. Hair tail, down row only.
4. Cloak, down row only.
5. Body, full texture.
6. Pants or boots, depending on `boots_over_pants`.
7. Boots or pants, depending on `boots_over_pants`.
8. Shirt, full texture.
9. Chest, full texture.
10. Long shirt, full texture.
11. Necklace, full texture.
12. Shoulders, full texture.
13. Waist, full texture.
14. Arms, full texture.
15. Right hand, left/right rows.
16. Cloak, left/right/up rows.
17. Hair tail, left/right/up rows.
18. Hair, full texture.
19. Hat, full texture.
20. Left hand, down row only.
21. Right hand, down row only.

### People Traits

REFMAP also provides `MapEntityTraits` schemas for people visuals. Use these when the visual data belongs to the
`MapEntity` instead of being controlled directly by the visual node.

The trait property names intentionally match the visual property names. REFMAP people visuals listen to their owning
entity's `traits_updated` signal and copy matching properties into the visual.

```gdscript
extends AlephVault__WindRose.Contrib.Simple.MapEntity

static var _traits_schema := AlephVault__WindRose__REFMAP.Traits.People.Standard.new()

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema
```

Then update traits on the entity:

```gdscript
traits = {
	&"sex": AlephVault__WindRose__REFMAP.Visuals.People.Base.Sex.Male,
	&"body": AlephVault__WindRose__REFMAP.Visuals.People.Base.BodyColor.White,
	&"hair": "1",
	&"hair_color": AlephVault__WindRose__REFMAP.Visuals.People.Base.ComponentColor.Black,
	&"shirt": "1",
	&"shirt_color": AlephVault__WindRose__REFMAP.Visuals.People.Base.ComponentColor.Blue,
}
```

Trait updates are partial. Assigning `{&"hair": "2"}` only changes `hair`; existing trait values are preserved.
Unknown trait keys are ignored with a warning by the base WindRose traits logic.

The schema instance should be cached, typically as a `static var`, because schemas are immutable after construction and
only describe the available fields. The schema does not update visuals directly; visual updates happen from
`traits_updated` listeners.

#### Simple People Traits

Use:

```gdscript
AlephVault__WindRose__REFMAP.Traits.People.Simple
```

Available traits:

- `sex`
- `body`
- `hair`, `hair_color`
- `hair_tail`, `hair_tail_color`
- `necklace`
- `hat`, `hat_color`
- `right_hand`
- `left_hand`
- `cloth`

#### Standard People Traits

Use:

```gdscript
AlephVault__WindRose__REFMAP.Traits.People.Standard
```

Available traits:

- `sex`
- `body`
- `hair`, `hair_color`
- `hair_tail`, `hair_tail_color`
- `necklace`
- `hat`, `hat_color`
- `right_hand`
- `left_hand`
- `boots`, `boots_color`
- `pants`, `pants_color`
- `shirt`, `shirt_color`
- `chest`, `chest_color`
- `waist`, `waist_color`
- `arms`, `arms_color`
- `long_shirt`, `long_shirt_color`
- `shoulders`, `shoulders_color`
- `cloak`
- `boots_over_pants`

### Bundled Default Resolver

`DefaultResolver` loads from:

```text
res://addons/AlephVault.WindRose.REFMAP/images/{Sex}/{Subcategory}/{Key}.png
```

Sex directories are `Male` and `Female`.

Body lookups use subcategory `Base` and these keys:

- `Black_e`
- `Blue_e`
- `Green_e`
- `Orange_e`
- `Purple_e`
- `Red_e`
- `White_e`
- `Yellow_e`

Supported non-body bundled categories are:

- `arms` -> `Arms`
- `boots` -> `Boots`
- `chest` -> `Chest`
- `hair` -> `Hair`
- `hair_tail` -> `Hair`
- `hat` -> `Hat`
- `long_shirt` -> `LongShirt`
- `pants` -> `Pants`
- `shirt` -> `Shirt`
- `shoulders` -> `Shoulder`
- `waist` -> `Waist`

For `hair_tail`, the file key is `{key}_{color}_b`. For the other supported component types, the file key is `{key}_{color}`.

The bundled resolver intentionally returns `null` for `right_hand`, `left_hand`, `cloth`, `necklace`, and `cloak`; provide these through a custom resolver or direct pairs.

Licenses
--------

The assets contained in this package come from REFMAP. While contact is not necessary to use these assets, credits should (at least in spite of some respect or gratitude) to:

    REFMAP / FSM
    - Blog: [http://refmap-l.blog.jp/](http://refmap-l.blog.jp/).
    - Twitter: [@refmap_fsm](https://twitter.com/refmap_fsm).

These files can be used according to the following terms:

    - They can be used for free as a material for game creation.
    - In use, contact is not necessary.
    - You can distribute* processed image data (but distribution* of UNPROCESSED image data is prohibited: Ban on sale).
      - (* since these assets already need no contact to use freely, "distribution" in this context means "sale").
    - The right of these images is owned by "REFMAP".
