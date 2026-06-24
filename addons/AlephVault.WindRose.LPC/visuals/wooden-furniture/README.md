# Wooden Furniture Visuals

This folder contains `StaticMapEntityVisual` implementations backed by `images/wooden-furniture/*.png`.

All concrete visuals inherit `AlephVault__WindRose__LPC.Visuals.WoodenFurniture.Base`, so they expose:

- `tone`: `DARK`, `BLONDE`, `GREEN`, or `WHITE`.
- `texture_cache_max_disposal_size`: static maximum disposal queue size for composed furniture textures. Set it before the first composed furniture visual refreshes.

The composed texture cache key is `AlephVault.WindRose.LPC:wooden-furniture`.

The base visual forces nearest texture filtering, disabled texture repeat, and clipped sprite regions. This keeps atlas-backed furniture from sampling neighbouring sprites when the camera zoom changes.

Sample
------

Open `res://addons/AlephVault.WindRose.LPC/samples/wooden-furniture/sample-aleph-vault-windrose-lpc-wooden-furniture-usage.tscn` to see every wooden furniture visual in this module. The sample builds a WindRose map using the simple squared map/entity stack, then creates one 6x6-tile map entity per furniture visual at sparse, non-overlapping positions. Each furniture visual is attached to its own entity through the normal map visual lifecycle.

Controls:

- `Tab`: select the next object.
- Arrow keys: move the camera.
- `1`: zoom in.
- `2`: zoom out.
- `Q`: cycle the selected object's primary property.
- `W`: cycle the selected object's secondary property.
- `E`: cycle wood tone.
- `R`: cycle orientation when supported.
- `F`: cycle clock FPS.

Inventory
---------

| Visual | Orientation | Rects / composition | Offset | Properties |
| ------ | ----------- | ------------------- | ------ | ---------- |
| `KitchenWideDesk` | Down only | `(96, 0, 64, 64)` | `Vector2(0, -32)` | None |
| `KitchenDesk` | Down only | `(160, 0, 32, 64)` | `Vector2(0, -32)` | None |
| `KitchenSink` | Down only | `(192, 0, 32, 64)` | `Vector2(0, -32)` | None |
| `KitchenStove` | Down only | `(224, 0, 32, 64)` | `Vector2(0, -32)` | None |
| `KitchenShelvedDesk` | Down only | `(256, 0, 32, 64)` | `Vector2(0, -32)` | None |
| `KitchenSidedWideDesk` | Left/right | Left `(96, 64, 32, 96)`, right `(128, 64, 32, 96)` | `Vector2(0, -32)` | None |
| `BigDesk` | Down only | Type 1 `(64, 704, 64, 64)`, type 2 `(128, 704, 64, 64)` | `Vector2(0, -32)` | `desk_type` |
| `SidedBigDesk` | Left/right | Right `(0, 704, 32, 96)`, left `(32, 704, 32, 96)` | `Vector2(0, -32)` | None |
| `Clock` | Down only | Four composed frames from `(256, 736, 32, 96)`, `(288, 736, 32, 96)`, `(320, 736, 32, 96)`, `(288, 736, 32, 96)` | `Vector2(0, -64)` | `fps` |
| `Fireplace` | Down only | Type 1 `(384, 736, 96, 96)`, type 2 `(416, 928, 96, 96)` | `Vector2(0, -64)` | `fireplace_type` |
| `ChurchSeat` | Up/down | Down `(0, 800, 96, 32)`, up `(96, 800, 96, 32)` | `Vector2.ZERO` | None |
| `GrandPiano` | Down only | `(0, 832, 64, 96)` | `Vector2(0, -32)` | None |
| `UprightPiano` | Down only | `(64, 832, 64, 96)` | `Vector2(0, -32)` | None |
| `OrganPiano` | Down only | `(160, 832, 96, 96)` | `Vector2(0, -64)` | None |
| `HorizontalPlankTable` | Up/down | `(256, 832, 96, 64)` for both | `Vector2(0, -32)` | None |
| `VerticalPlankTable` | Left/right | `(352, 832, 32, 96)` for both | `Vector2(0, -32)` | None |
| `HorizontalPlankBank` | Up/down | `(256, 896, 64, 32)` for both | `Vector2.ZERO` | None |
| `VerticalPlankBank` | Left/right | `(384, 832, 32, 96)` for both | `Vector2(0, -32)` | None |
| `BigPlankTable` | Down only | `(416, 832, 96, 96)` | `Vector2(0, -32)` | None |
| `VerticalFurniture` | Down only | Composed `32x93` region from atlas parts | `Vector2(0, -80)` | `furniture_type`, `furniture_legs_type` |
| `RoundTable` | Down only | `(224, 224, 64, 64)` | `Vector2.ZERO` | None |
| `Stool1` | Down only | Normal `(448, 256, 32, 32)`, worn `(448, 224, 32, 32)` | `Vector2.ZERO` | `worn` |
| `Stool2` | Down only | Normal `(480, 256, 32, 32)`, worn `(480, 224, 32, 32)` | `Vector2.ZERO` | `worn` |
| `TwinBed` | Down only | Type 1 `(416, 416, 32, 64)`, type 2 `(448, 418, 32, 64)`, type 3 `(480, 416, 32, 64)` | `Vector2(0, -64)` | `bed_type` |
| `Chair` | Up/down/left/right | 32x32 directional group selected by `chair_type` and `worn` | `Vector2.ZERO` | `chair_type`, `worn` |
| `WideShelving` | Down only | Normal `(256, 352, 64, 64)`, worn `(256, 288, 64, 64)` | `Vector2(0, -48)` | `worn` |
| `WideGondola` | Down only | Normal `(320, 352, 64, 64)`, worn `(320, 288, 64, 64)` | `Vector2(0, -48)` | `worn` |
| `WideMidDrawers` | Down only | Normal `(64, 368, 64, 48)`, worn `(64, 304, 64, 48)` | `Vector2(0, -32)` | `worn` |
| `WideSmallShelving` | Down only | Normal `(0, 368, 64, 48)`, worn `(0, 304, 64, 48)` | `Vector2(0, -32)` | `worn` |
| `WideSmallDesk` | Down only | Normal `(128, 368, 64, 48)`, worn `(128, 304, 64, 48)` | `Vector2(0, -32)` | `worn` |
| `WideWardrobe` | Down only | Normal `(192, 352, 64, 64)`, worn `(192, 288, 64, 64)` | `Vector2(0, -48)` | `worn` |
| `SmallShelving` | Down only | Normal `(384, 352, 32, 64)`, worn `(384, 288, 32, 64)` | `Vector2(0, -48)` | `worn` |
| `SmallWardrobe` | Down only | Normal `(416, 352, 32, 64)`, worn `(416, 288, 32, 64)` | `Vector2(0, -48)` | `worn` |
| `SmallDrawer` | Down only | Normal `(448, 352, 32, 32)`, worn `(448, 288, 32, 32)` | `Vector2(0, -16)` | `worn` |
| `NightStand` | Down only | Normal `(480, 352, 32, 32)`, worn `(480, 288, 32, 32)` | `Vector2(0, -16)` | `worn` |
| `WideSmallDrawer` | Down only | Normal `(480, 320, 64, 32)`, worn `(448, 320, 64, 32)` | `Vector2(0, -16)` | `worn` |
| `Shelving` | Down only | `(320, 416, 32, 64)` | `Vector2(0, -48)` | None |
| `Drawers` | Down only | `(352, 416, 32, 64)` | `Vector2(0, -48)` | None |
| `MidDrawers` | Down only | `(384, 416, 32, 64)` | `Vector2(0, -48)` | None |
| `ChessTable` | Down only | `(64, 408, 32, 32)` | Base default | None |
| `BigWardrobe` | Down only | `(0, 608, 64, 96)` | `Vector2(0, -80)` | None |
| `BigTable` | Down only | `(128, 160, 96, 96)` | `Vector2(0, -16)` | None |
| `VerticalMidBank` | Down only | `(96, 224, 32, 64)` | `Vector2.ZERO` | None |
| `HorizontalMidBank` | Down only | `(128, 256, 64, 32)` | `Vector2.ZERO` | None |
| `Column` | Down only | `(480, 736, 32, 80)` | `Vector2(0, -48)` | None |
| `TinyDrawer` | Down only | Type 1 `(192, 768, 32, 32)`, type 2 `(224, 768, 32, 32)` | `Vector2(0, -16)` | `drawer_type` |
| `DoubleTinyDrawer` | Down only | Type 1 `(192, 736, 32, 32)`, type 2 `(224, 768, 32, 32)` | `Vector2(0, -16)` | `drawer_type` |
| `VerticalDoubleBunkBed` | Down only | `(192, 608, 64, 96)` | `Vector2(0, -32)` | None |
| `HorizontalBunkBed` | Down only | `(288, 608, 96, 96)` | `Vector2(0, -48)` | None |

Configurable Objects
--------------------

### `BigDesk`

`desk_type: BigDeskType`

- `DESK_TYPE_1`
- `DESK_TYPE_2`

### `Clock`

`fps: int` controls animation speed. The default is `2`.

### `Fireplace`

`fireplace_type: FireplaceType`

- `FIREPLACE_TYPE_1`
- `FIREPLACE_TYPE_2`

### `TwinBed`

`bed_type: BedType`

- `BED_TYPE_1`
- `BED_TYPE_2`
- `BED_TYPE_3`

### `Chair`

`chair_type: ChairType`

- `CHAIR_TYPE_1`
- `CHAIR_TYPE_2`
- `CHAIR_TYPE_3`
- `CHAIR_TYPE_4`
- `CHAIR_TYPE_5`
- `CHAIR_TYPE_6`
- `CHAIR_TYPE_7`

`worn: bool` switches the worn variant for `CHAIR_TYPE_1`.

### `TinyDrawer` and `DoubleTinyDrawer`

`drawer_type: TinyDrawerType`

- `TINY_DRAWER_1`
- `TINY_DRAWER_2`

### Worn Variants

These visuals expose `worn: bool`: `Stool1`, `Stool2`, `Chair`, `WideShelving`, `WideGondola`, `WideMidDrawers`, `WideSmallShelving`, `WideSmallDesk`, `WideWardrobe`, `SmallShelving`, `SmallWardrobe`, `SmallDrawer`, `NightStand`, and `WideSmallDrawer`.

### `VerticalFurniture`

`furniture_type: VerticalFurnitureType`

- `DRAWERS`
- `BOOKSHELVES`
- `EMPTIED_BOOKSHELVES`
- `DISH_SHELVES`
- `EMPTIED_DISH_SHELVES`
- `DRAWERS_2`
- `EMPTIED_DISH_SHELVES_2`

`furniture_legs_type: VerticalFurnitureLegsType`

- `SMALL`
- `BIG`

`VerticalFurniture` uses `Context` and `Step` to build a cached composed texture. Its body starts with `(352, 0, 32, 32)` at `(0, 0)`, then pastes the selected middle at `(0, 32)`. Small legs paste `(X, 160, 32, 27)` and `(X, 187, 32, 5)`. Big legs paste `(Z, 192, 32, 32)` and `(480, 211, 32, 13)`.

The X/Z mapping is:

| Type | X | Z |
| ---- | - | - |
| `DRAWERS` | 288 | 288 |
| `EMPTIED_DISH_SHELVES` | 320 | 320 |
| `BOOKSHELVES` | 352 | 352 |
| `EMPTIED_BOOKSHELVES` | 384 | 384 |
| `DISH_SHELVES` | 416 | 416 |
| `DRAWERS_2` | 448 | 288 |
| `EMPTIED_DISH_SHELVES_2` | 480 | 448 |
