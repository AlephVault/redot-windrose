# Mansion Visual

The mansion visual is implemented by
`AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Mansion`.

It is a tool-mode static map entity visual that composes a large Victorian mansion
texture from `res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/mansion.png`.
Changing any exported mansion property releases the previous composed texture and
regenerates a new one. Generated textures are stored in the shared LRU texture cache
identified by `AlephVault.WindRose.LPC:victorian-real-estate`.

A runnable sample scene is available at
`res://addons/AlephVault.WindRose.LPC/samples/victorian-real-estate/sample-aleph-vault-windrose-lpc-victorian-real-estate-usage.tscn`.

## Usage

Create the visual and attach it to a map entity like any other WindRose static visual:

```gdscript
const _VictorianRealEstate = AlephVault__WindRose__LPC.Visuals.VictorianRealEstate
const _MansionCore = preload(
	"res://addons/AlephVault.WindRose.LPC/visuals/victorian-real-estate/mansion_parts/core.gd"
)

var mansion := _VictorianRealEstate.Mansion.new()
mansion.design = _MansionCore.Design.BIG_C_SHAPE
mansion.stories = _MansionCore.Stories.DOUBLE
entity.add_visual(mansion)
```

The sample uses the internal `mansion_parts/core.gd` enum constants when cycling
properties from code. In the Godot inspector, the exported enum properties expose
the same names directly.

## Public Properties

### Overall Shape

- `design`: Selects the floor-plan silhouette. Available values are `LINE_SHAPE`,
  `T_SHAPE`, `LITTLE_C_SHAPE`, `BIG_C_SHAPE`, and `E_SHAPE`.
- `stories`: Selects the vertical size. Available values are `SINGLE` and `DOUBLE`.
- `depth`: Selects the roof depth. Available values are `SINGLE` and `DOUBLE`.

### Colors and Lighting

- `roof_color`: Selects the roof palette. Available values are `PURPLE`, `GRAY`,
  `BLUE`, `GREEN`, `RED`, `BROWN`, `WHITE`, `BLACK`, `WORN_RED`, and `WORN_GREEN`.
- `wall_color`: Selects the wall palette. Available values are `YELLOW`, `RED`,
  `GREEN`, `GRAYBLUE`, `BLUE`, and `PURPLE`.
- `light_mode`: Selects window lighting. Available values are `DAY`, `NIGHT_OFF`,
  and `NIGHT_ON`.

### Windows and Prongs

Mansion layouts contain facade blocks called prongs. The mansion can render these
blocks with windows, box windows, columns, or bricked wall details depending on the
properties below.

- `use_bricked_prongs`: When `true`, prong blocks use the bricked wall variant
  instead of the regular wall treatment.
- `first_floor_prongs`: Selects what appears on first-floor prong blocks.
  Available values are `REGULAR_WINDOWS`, `BOX_WINDOWS`, and `COLUMNS`.
- `prong_window_color`: Selects the window palette for prong windows. Available
  values are `CLASSIC`, `BLACK`, `WHITE`, `YELLOW`, `RED`, `GREEN`, and `BROWN`.
- `prong_window_index`: Selects the flat-window variant used on prong windows.
  `CLASSIC` windows support indices `0-1`; the other window colors support
  indices `0-15`. Values outside those ranges are clamped by the composer.
- `non_prong_window_color`: Selects the window palette for windows outside prong
  blocks. It uses the same values as `prong_window_color`.
- `non_prong_window_index`: Selects the flat-window variant used outside prong
  blocks. It uses the same index rules as `prong_window_index`.

`CLASSIC` windows use white frames with curtain colors derived from `wall_color`.
The other window palettes use colored modern window designs.

### Door, Doorframe, and Steps

- `door_shape`: Selects the door sprite family. Available values are
  `RECTANGULAR`, `ROUNDED`, `ROUNDED2`, `ROUNDED_LARGE`, `ROUNDED2_LARGE`, and
  `ROUNDED3_LARGE`.
- `door_index`: Selects a door variant within the selected `door_shape`.
  Rectangular doors wrap over `0-39`; rounded and rounded2 doors wrap over `0-4`;
  large rounded door families wrap over `0-6`.
- `is_door_open`: When `true`, renders the open-door treatment.
- `has_doorframe`: When `true`, renders a doorframe around the door.
- `doorframe_color`: Selects the doorframe palette. Available values are
  `ORANGE_LIGHT`, `ORANGE_MID`, `ORANGE_DARK`, `BROWN_LIGHT`, `BROWN_MID`,
  `BROWN_DARK`, `GRAY_LIGHT`, `GRAY_MID`, and `GRAY_DARK`.
- `doorframe_index`: Selects one of the available doorframe styles. Valid styles
  are `0-6`.
- `doorsteps_color`: Selects the doorstep palette. Available values are
  `GRAY_LIGHT`, `GRAY_DARK`, `BLUE_LIGHT`, `BLUE_MID_LIGHT`, `BLUE_MID`,
  `BLUE_MID_DARK`, and `BLUE_DARK`.

## Generated Texture Size and Pivot

Mansion textures are composed from 96x96 blocks. The generated texture width is the
layout block width plus one extra 96px shadow area. The generated texture height is
the layout block height plus story and depth adjustments; most designs also reserve
16px of extra vertical space for elements such as doorframes and steps.

Approximate block widths are:

- `LINE_SHAPE`, `T_SHAPE`, and `LITTLE_C_SHAPE`: 3 layout blocks.
- `BIG_C_SHAPE` and `E_SHAPE`: 5 layout blocks.

The visual sets `centered = false` and computes an upward offset from the number of
stories. This keeps the mansion anchored to the owning map entity while allowing the
rendered building to extend above that anchor.

## Notes

- The mansion is static from the map entity perspective, but the texture is
  generated dynamically when edited or configured.
- Texture generation is debounced while the visual is inside the scene tree, so
  rapid property changes are coalesced before recomposition.
- The inherited `Sprite2D` frame and region properties are intentionally hidden in
  the inspector because the mansion owns its generated texture setup.
