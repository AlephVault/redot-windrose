# WindRose.LPC

This package contains LPC-related resources which are optional to the WindRose games. They come in two flavors:

- For Blocking or Simple games (or, perhaps, rules relying on tiles having "blocking" property only), there's a `tiles/lpc-tiles-simple.tres`.
- For Blocking + Navigability games (i.e. more complex games where lava / water vehicles exist), there's a `tiles/lpc-tiles-full.tres`.

Both resources are orthogonal (these LPC tiles are only orthogonal) and only 32x32 tiles.

Usage
-----

To use the farm visuals, a matching LPC visual must be added to the entity that should render it. The sections below describe the public properties exposed by each available farm visual.

### Barn

The barn visual is implemented by `AlephVault__WindRose__LPC.Visuals.Farm.Barn`.

- `flavor`: Selects the barn size variant. Available values are `SMALL`, `MEDIUM`, and `BIG`.
- `gate_status`: Controls whether the front gate is rendered as `OPEN` or `CLOSED`.

### House

The house visual is implemented by `AlephVault__WindRose__LPC.Visuals.Farm.House`.

- `texture_cache_name`: LRU cache key used for the composed house texture.
- `wall_color`: Selects the wall brick color. Available values are `LIGHT_BLUE`, `LIGHT_GRAY`, `GRAY`, `LIGHT_BROWN`, `BROWN`, and `RED`.
- `ceiling_color`: Selects the ceiling brick color. Available values are `LIGHT_BLUE`, `LIGHT_GRAY`, `GRAY`, `LIGHT_BROWN`, `BROWN`, and `RED`.
- `chimney_color`: Selects the chimney brick color. Available values are `LIGHT_BLUE`, `LIGHT_GRAY`, `GRAY`, `LIGHT_BROWN`, `BROWN`, and `RED`.
- `lights_on`: Enables the lit overlays used by the house.
- `door_color`: Selects the door color. Available values are `RED`, `YELLOW`, `GREEN`, `BLUE`, `WHITE`, `MID_WHITE`, `MID_DARK`, `DARK`, `BROWN1_LIGHT`, `BROWN1_MID_LIGHT`, `BROWN1_MID_DARK`, `BROWN1_DARK`, `BROWN2_LIGHT`, `BROWN2_MID_LIGHT`, `BROWN2_MID_DARK`, and `BROWN2_DARK`.
- `door_is_open`: Controls whether the door is open.
- `door_has_windows`: Controls whether the closed-door variant uses windows.
- `doorframe_color`: Selects the doorframe color. Available values are `ORANGE_LIGHT`, `ORANGE_MID`, `ORANGE_DARK`, `BROWN_LIGHT`, `BROWN_MID`, `BROWN_DARK`, `GRAY_LIGHT`, `GRAY_MID`, `GRAY_DARK`, `BLUE_LIGHT`, `BLUE_MID`, and `BLUE_DARK`.
- `has_doorframe`: Controls whether the doorframe is rendered.
- `doorsteps_color`: Selects the doorstep color. Available values are `GRAY_LIGHT`, `GRAY_DARK`, `BLUE_LIGHT`, `BLUE_MID_LIGHT`, `BLUE_MID`, `BLUE_MID_DARK`, and `BLUE_DARK`.

Licenses
--------

The assets contained in this package come from the LPC authoring contest. Credits must be given (for those assets) to:

1. For the tiles:

	   Liberated Pixel Cup (LPC) Base Assets 
	   Lanea Zimmerman (Sharm)
	   CC-BY-SA 3.0 / CC-BY 3.0 / GPL 3.0
	   https://opengameart.org/content/liberated-pixel-cup-lpc-base-assets-sprites-map-tiles

2. For the Farm's Barn and House

   House elements:

	   12-Panel Door, 15-Panel Door
	   -------------------
		 ARTIST(S): Lanea Zimmerman (Sharm), Eliza Wyatt
		 SOURCE: https://opengameart.org/content/lpc-animated-doors
		 LICENSE: CC-by-SA 3, DRM waived by Lanea Zimmerman
		 DETAILS: Original design and animation by Lanea Zimmerman. Converted to 15 panel door by Eliza Wyatt. Recolors by Eliza Wyatt.

	   Doorframe A
	   -------------------
		 ARTIST(S): Lanea Zimmerman (Sharm), Eliza Wyatt
		 SOURCE: https://opengameart.org/content/lpc-interior-castle-tiles
		 LICENSE: CC-by-SA 3, DRM waived by Lanea Zimmerman
		 DETAILS: Original doorframe by Lanea Zimmerman. Recolors and adjustments by Eliza Wyatt.

	   Doorframe B
	   -------------------
		 ARTIST(S): Lanea Zimmerman (Sharm), Eliza Wyatt
		 SOURCE: https://opengameart.org/content/lpc-arabic-elements
		 LICENSE: CC-by-SA 3, DRM waived by Lanea Zimmerman
		 DETAILS: Original doorway by Lanea Zimmerman. Recolors and adjustments by Eliza Wyatt.

   Barn elements:

	   "[LPC] Farm" by bluecarrot16, Wolthera van Hövell tot Westerflier (TheraHedwig), and Ivan Voirol
	   http://opengameart.org/content/lpc-farm

	   Based on:

	   Slates [32x32px orthogonal tileset by Ivan Voirol]
	   Ivan Voirol
	   CC-BY 4.0
	   https://opengameart.org/content/slates-32x32px-orthogonal-tileset-by-ivan-voirol

	   LPC compatible Ancient Greek Architecture
	   Wolthera van Hövell tot Westerflier (TheraHedwig)
	   CC-BY-4.0 / GPL-3.0 / OGA-BY-3.0
	   https://opengameart.org/content/lpc-compatible-ancient-greek-architecture
