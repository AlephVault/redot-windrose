# Victorian Street Appliances Visuals

This folder contains `StaticMapEntityVisual` implementations backed by `images/victorian-decoration/street-appliances.png`.

All concrete visuals inherit `AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances.Base`, so they share:

- `texture_cache_max_disposal_size`: static maximum disposal queue size for composed appliance textures. Set it before the first composed appliance visual refreshes.
- Cached composition through `AlephVault__WindRose.Utils.Textures.Context` and `AlephVault__WindRose.Utils.Textures.Step`.
- Nearest texture filtering, disabled texture repeat, and clipped sprite regions to avoid atlas bleeding during zoom.

The composed texture cache key is `AlephVault.WindRose.LPC:victorian-street-appliances`.

Sample
------

Open `res://addons/AlephVault.WindRose.LPC/samples/victorian-street-appliances/sample-aleph-vault-windrose-lpc-victorian-street-appliances-usage.tscn` to see the current Victorian street appliance visuals. The sample builds a WindRose map using the simple squared map/entity stack, then creates one 6x6-tile map entity per visual at sparse, non-overlapping positions. Each occupied square is painted below its entity.

Controls:

- `Tab`: select the next object.
- Arrow keys: move the camera.
- `1`: zoom in.
- `2`: zoom out.
- `Q`: cycle the selected object's primary property when supported.
- `S`: toggle OFF/ON for streetlights.
- `R`: cycle orientation when supported.
- `F`: cycle FPS for animated streetlights.
- For `BigSquareFountainPool`, `Q` toggles `include_fountain`.

States
------

Streetlights use the owning map entity state:

- `STATE_OFF`: `AlephVault__WindRose.Maps.MapEntity.STATE_IDLE`
- `STATE_ON`: `AlephVault__WindRose.Maps.MapEntity.STATE_MOVING`

Inventory
---------

| Visual | Orientation | Size | Offset | States | Properties |
| ------ | ----------- | ---- | ------ | ------ | ---------- |
| `FancyWideStreetLight` | Down only | `64x96` | `Vector2(-16, -64)` | OFF static, ON 4-frame animation at default `fps = 4` | None |
| `FancyStreetLight` | Down only | `32x96` | `Vector2(0, -64)` | OFF static, ON 4-frame animation at default `fps = 4` | `lamp_type` with 2 variants |
| `StreetLight` | Down only | `32x96` | `Vector2(0, -64)` | OFF static, ON 4-frame animation at default `fps = 4` | `lamp_type` with 8 variants |
| `StreetClock` | Down only | `32x96` | `Vector2(0, -64)` | Static | `clock_type` with 2 variants |
| `BannerPost` | Down only | `64x128` | `Vector2(-16, -96)` | Static | `banner_color` with `NONE`, `WHITE`, `YELLOW`, `BLUE`, `RED`, `GREEN` |
| `SunBlind` | Down only | White `(512, 224, 96, 96)`, yellow `(640, 224, 96, 96)`, liteblue `(512, 320, 96, 96)`, red `(640, 320, 96, 96)`, green `(512, 416, 96, 96)`, brown `(640, 416, 96, 96)` | `Vector2(0, (3 + level) * -32)` | Static | `color` with `COLOR_WHITE`, `COLOR_YELLOW`, `COLOR_LITEBLUE`, `COLOR_RED`, `COLOR_GREEN`, `COLOR_BROWN`; `level >= 0` |
| `BigDome` | Down only | Region `(512, 0, 224, 224)` | `Vector2(0, -96)` | Static | None |
| `WhiteFenceEntrance` | Down only | Region `(0, 192, 96, 96)` | `Vector2(-32, -64)` | Static | None |
| `BigWoodEntrance` | Down only | Region `(96, 192, 96, 128)` | `Vector2(0, -96)` | Static | None |
| `WoodEntrance` | Down only | Region `(192, 192, 96, 128)` | `Vector2(0, -96)` | Static | None |
| `GrassEntrance` | Down only | Region `(288, 224, 64, 96)` | `Vector2(16, -64)` | Static | None |
| `GrassRing` | Down only | Region `(352, 256, 64, 64)` | `Vector2(0, -32)` | Static | None |
| `RoundFountainPool` | Down only | Four composed frames from `(0, 320, 64, 64)`, `(64, 320, 64, 64)`, `(128, 320, 64, 64)`, `(64, 320, 64, 64)` | `Vector2(0, -32)` | 4-frame animation at default `fps = 4` | `fps` |
| `BigSquareFountainPool` | Down only | Four composed frames from `(192, 320, 96, 96)`, `(288, 320, 96, 96)`, `(384, 320, 96, 96)`, `(288, 320, 96, 96)` | `Vector2(0, -32)` | 4-frame animation at default `fps = 4` | `fps`, `include_fountain` |
| `StandaloneFountain` | Down only | Four composed `64x96` frames | `Vector2(0, -32)` | 4-frame animation at default `fps = 4` | `fps`, `fountain_type` with 2 variants |
| `WallFountain` | Down only | Three composed frames from `(448, 128, 64, 64)`, `(448, 192, 64, 64)`, `(448, 256, 64, 64)` | `Vector2(0, -64)` | 3-frame animation at default `fps = 4` | `fps` |
| `SmallFlowerBed` | Up/down horizontal, left/right vertical | Horizontal type 1 `(320, 480, 32, 32)`, horizontal type 2 `(320, 512, 32, 32)`, vertical type 1 `(384, 480, 32, 64)`, vertical type 2 `(352, 480, 32, 64)` | Horizontal `Vector2.ZERO`, vertical `Vector2(0, -32)` | Static | `flower_type` |
| `SmallWoodenPlantPot` | Down only | None `(288, 480, 32, 32)`, dirt `(288, 512, 32, 32)`, pine `(192, 480, 32, 64)`, bush `(224, 480, 32, 64)`, tree `(256, 480, 32, 64)` | None/dirt `Vector2.ZERO`, pine/bush/tree `Vector2(0, -32)` | Static | `content` with `CONTENT_NONE`, `CONTENT_DIRT`, `CONTENT_PINE`, `CONTENT_BUSH`, `CONTENT_TREE` |
| `TinyClayBushPot` | Down only | Region `(128, 512, 32, 64)` | `Vector2(0, -32)` | Static | None |
| `SmallHorizontalClayFlowerBed` | Down only | Dirt `(0, 512, 64, 64)`, bush `(128, 512, 64, 64)` | `Vector2(0, -32)` | Static | `content` with `CONTENT_DIRT`, `CONTENT_BUSH` |
| `VerticalClayFlowerBed` | Down only | Dirt `(0, 576, 64, 96)`, bush purple flowers `(64, 576, 64, 96)`, bush yellow flowers `(128, 576, 64, 96)`, purple flowers `(0, 672, 64, 96)`, liteblue flowers `(64, 672, 64, 96)`, red flowers `(128, 672, 64, 96)` | `Vector2(-16, -16)` | Static | `content` with `CONTENT_DIRT`, `CONTENT_BUSH_PURPLE_FLOWERS`, `CONTENT_BUSH_YELLOW_FLOWERS`, `CONTENT_PURPLE_FLOWERS`, `CONTENT_LITEBLUE_FLOWERS`, `CONTENT_RED_FLOWERS` |
| `RoundedBushPot` | Down only | Dirt `(0, 768, 64, 64)`, daisies bush `(0, 832, 64, 64)`, spiky bush `(0, 896, 64, 64)` | `Vector2.ZERO` | Static | `content` with `CONTENT_DIRT`, `CONTENT_DAISIES_BUSH`, `CONTENT_SPIKY_BUSH` |
| `BigTreeBed` | Down only | Region `(192, 672, 96, 96)` | `Vector2.ZERO` | Static | None |
| `HorizontalClayFlowerBed` | Down only | Computed `(X, Y, 96, 64)`, where `X = 64 + (index / 3) * 96` and `Y = 768 + (index % 3) * 64` | `Vector2(0, -16)` | Static | `content` with `CONTENT_DIRT`, `CONTENT_BUSH`, `CONTENT_BUSHES`, `CONTENT_FLOWER_PURPLE`, `CONTENT_FLOWER_WHITE`, `CONTENT_FLOWER_YELLOW`, `CONTENT_FLOWER_ROSES_AND_YELLOW`, `CONTENT_FLOWER_RED`, `CONTENT_FLOWER_ORANGE`, `CONTENT_FLOWER_LITEBLUE`, `CONTENT_FLOWER_ROSES_AND_PURPLE`, `CONTENT_FLOWERS_PURPLE2` |
| `TinyWoodenPlantBed` | Down only | None `(480, 608, 32, 32)`, dirt `(480, 640, 32, 32)`, bush `(480, 672, 32, 64)` | None/dirt `Vector2.ZERO`, bush `Vector2(0, -32)` | Static | `content` with `CONTENT_NONE`, `CONTENT_DIRT`, `CONTENT_BUSH` |
| `WoodenPlantBed` | Down only | None `(416, 608, 64, 32)`, flowers `(416, 640, 64, 32)`, bush `(416, 672, 64, 64)` | None/flowers `Vector2.ZERO`, bush `Vector2(0, -32)` | Static | `content` with `CONTENT_NONE`, `CONTENT_FLOWERS`, `CONTENT_BUSH` |
| `VerticalWoodenPlantBed` | Down only | None `(352, 608, 32, 64)`, flowers 1 `(384, 608, 32, 64)`, bush `(352, 672, 32, 64)`, flowers 2 `(384, 672, 32, 64)` | `Vector2.ZERO` | Static | `content` with `CONTENT_NONE`, `CONTENT_FLOWERS1`, `CONTENT_BUSH`, `CONTENT_FLOWERS2` |
| `CeramicPlantPot` | Down only | None `(192, 544, 32, 32)`, dirt `(192, 576, 32, 32)`, pine `(224, 544, 32, 64)`, tree 1 `(256, 544, 32, 64)`, tree 2 `(288, 544, 32, 64)`, tree 3 `(320, 544, 32, 64)`, red flowers `(352, 544, 32, 64)`, liteblue flowers `(384, 544, 32, 64)`, roses `(416, 544, 32, 64)`, sunflowers `(448, 544, 32, 64)`, bush `(480, 544, 32, 64)` | None/dirt `Vector2.ZERO`, all other content `Vector2(0, -32)` | Static | `content` with `CONTENT_NONE`, `CONTENT_DIRT`, `CONTENT_PINE`, `CONTENT_TREE1`, `CONTENT_TREE2`, `CONTENT_TREE3`, `CONTENT_FLOWERS_RED`, `CONTENT_FLOWERS_LITEBLUE`, `CONTENT_ROSES`, `CONTENT_SUNFLOWERS`, `CONTENT_BUSH` |

Composition Notes
-----------------

`FancyWideStreetLight` builds two cached textures:

- OFF: paste post `(0, 0, 64, 64)` at `(0, 32)`, then lamp `(0, 64, 64, 32)` at `(0, 0)`.
- ON: four vertical frames. Each frame pastes post `(0, 0, 64, 64)` at `(0, frame_y + 32)` and light frame `(0, 96 + 32 * F, 64, 32)` at `(0, frame_y)`, with `F = [0, 1, 0, 2]`.

`FancyStreetLight` builds two cached textures:

- OFF: paste post `(64, 0, 32, 64)` at `(0, 32)`, then lamp `(64 + 32 * S, 64, 32, 32)` at `(0, 0)`.
- ON: four vertical frames. Each frame pastes post `(64, 0, 32, 64)` at `(0, frame_y + 32)` and light frame `(64 + 32 * S, 96 + 32 * F, 32, 32)` at `(0, frame_y)`, with `F = [0, 1, 0, 2]`.

`StreetLight` builds two cached textures:

- OFF: paste post `(128, 0, 32, 64)` at `(0, 32)`, then lamp `(128 + 32 * S, 64, 32, 32)` at `(0, 0)`.
- ON: four vertical frames. Each frame pastes post `(128, 0, 32, 64)` at `(0, frame_y + 32)` and light frame `(128 + 32 * S, 96 + 32 * F, 32, 32)` at `(0, frame_y)`, with `F = [0, 1, 0, 2]`.

`StreetClock` builds one cached texture per `clock_type`:

- `CLOCK_TYPE_1`: paste `(128, 0, 32, 64)` at `(0, 32)`, then `(160, 0, 32, 32)` at `(0, 0)`.
- `CLOCK_TYPE_2`: paste `(160, 32, 32, 32)` at `(0, 64)`, then `(192, 0, 32, 64)` at `(0, 0)`.

`BannerPost` builds one cached texture per `banner_color`:

- Paste `(96, 32, 32, 32)` at `(16, 0)`.
- Paste the banner rect at `(0, 32)`: `NONE` uses `(224, 0, 64, 32)`, `WHITE` uses `(288, 0, 64, 32)`, `YELLOW` uses `(224, 32, 64, 32)`, `BLUE` uses `(352, 0, 64, 32)`, `RED` uses `(352, 32, 64, 32)`, and `GREEN` uses `(288, 32, 64, 32)`.
- Paste `(128, 0, 32, 64)` at `(16, 64)`.

`BigSquareFountainPool` builds four cached animation frames. When `include_fountain` is `false`, each frame pastes its 96x96 source rect directly. When `include_fountain` is `true`, each frame also pastes `(X, Y + 69, 96, 64)` over the frame at `(0, 0)`.

`StandaloneFountain` builds four cached animation frames. For `FOUNTAIN_TYPE_1`, it pastes bottom rects from y `400`; for `FOUNTAIN_TYPE_2`, it uses y `464`. Bottom frame rects are `(0, Y, 64, 48)`, `(64, Y, 64, 48)`, `(128, Y, 64, 48)`, `(64, Y, 64, 48)` at `(0, 48)`. It then overlays top rects `(208, 416, 64, 64)`, `(304, 416, 64, 64)`, `(400, 416, 64, 64)`, `(304, 416, 64, 64)` at `(0, 0)`.
