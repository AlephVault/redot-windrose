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
- `Q`: cycle the selected object's style or type when supported.
- `S`: toggle OFF/ON for streetlights.
- `F`: cycle FPS for animated streetlights.

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
