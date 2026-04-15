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

### Fruit Trees

The fruit-tree visual is implemented by `AlephVault__WindRose__LPC.Visuals.Farm.FruitTrees`.

- `tree_type`: Selects the rendered tree species and fruit variant. Available values are `RED_APPLES`, `GREEN_APPLES`, `YELLOW_APPLES`, `VARIEGATED_APPLES`, `GOLDEN_APPLES`, `LEMON`, `LIME`, `TANGERINE`, `ORANGE`, `PEACH`, `MANGO1`, `MANGO2`, `RED_CHERRY`, `YELLOW_PEAR`, `BROWN_PEAR`, `GREEN_PEAR`, `PURPLE_PLUM`, `BROWN_COCONUT`, and `YELLOW_BANANA`.
- `tree_stage`: Selects the rendered growth stage. Available values are `BABY`, `SMALL`, `GROWING`, `ADULT`, `FRUITS_SMALL`, `FRUITS_GROWING`, and `FRUITS_READY`.

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

3. For the crops:

	   "[LPC] Crops" by bluecarrot16, Daniel Eddeland (daneeklu), Joshua Taylor, Richard Kettering (Jetrel). Commissioned by castelonia. License CC-BY-SA 3.0+ or GPL 3.0+. https://opengameart.org/content/lpc-crops
	
	   BASED ON:
	
	   [LPC] Farming tilesets, magic animations and UI elements
	   DE = Daniel Eddeland
	   CC-BY-SA 3.0 / GPL 3.0
	   https://opengameart.org/content/rpg-item-set
	
	   Fruit and Veggie Inventory
	   JT = Joshua Taylor
	   CC-BY-SA 3.0 / GPL 3.0
	   https://opengameart.org/content/fruit-and-veggie-inventory
	
	   RPG item set
	   RK = Richard Kettering (Jetrel)
	   CC0
	   https://opengameart.org/content/rpg-item-set
	
	   All items edited by bluecarrot16. Original authors listed, otherwise drawn from scratch by bluecarrot16.
	
	   - If you use this entire set, the license is CC-BY-SA 3.0+ or GPL v3.0+.
		 - All individual items can be used under either of those licenses (CC-BY-SA 3.0+ or GPL 3.0+).
		 - Some items can also be used under other licenses, according to the table below.
		 - For items with a CC-BY, CC-BY-SA, OGA-BY, or GPL license, you must credit the original author(s) as well as bluecarrot16, link to the original submissions (above) and include a link back to <https://opengameart.org/content/lpc-crops>.
		 - For items licensed CC0, credit and link back to this page is appreciated, but not required.
	
	   |                                    Item                                    | Other Authors |              Type             | Other Licenses |
	   |----------------------------------------------------------------------------|---------------|-------------------------------|----------------|
	   | Russet potatoes                                                            | JT, DE        | Potato root (DE)              |                |
	   | Gold potatoes                                                              | DE            | Potato root (DE)              |                |
	   | Purple potatoes                                                            | DE            | Potato root (DE)              |                |
	   | Sweet potatoes                                                             | DE            | Potato root (DE)              |                |
	   | Yuca / Cassava                                                             | DE            | Cassava                       |                |
	   | Daikon radish                                                              | DE            | Carrot root (DE)              |                |
	   | Carrots                                                                    | DE, JT        | Carrot root (DE)              |                |
	   | Parsnips                                                                   | DE, JT        | Carrot root (DE)              |                |
	   | Radishes                                                                   | DE, JT        | Carrot root (DE)              |                |
	   | Beets                                                                      | JT            | Beet/Turnip/Rutabaga root     |                |
	   | Turnips                                                                    | JT            | Beet/Turnip/Rutabaga root     |                |
	   | Rutabaga                                                                   | JT            | Beet/Turnip/Rutabaga root     |                |
	   | Garlic                                                                     | JT            | Onion/Garlic/Leek root        |                |
	   | Yellow onion / Sweet onion                                                 | JT            | Onion/Garlic/Leek             |                |
	   | Red onion / Purple onion                                                   | JT            | Onion/Garlic/Leek             |                |
	   | White onion                                                                | JT            | Onion/Garlic/Leek             |                |
	   | Green onion / Scallion                                                     | JT            | Onion/Garlic/Leek             |                |
	   | Hot pepper                                                                 | DE            | Pepper bush (DE)              |                |
	   | Green bell pepper                                                          | DE, JT        | Pepper bush (DE)              |                |
	   | Red bell pepper                                                            | DE, JT        | Pepper bush (DE)              |                |
	   | Orange bell pepper                                                         | DE, JT        | Pepper bush (DE)              |                |
	   | Yellow bell pepper                                                         | DE, JT        | Pepper bush (DE)              |                |
	   | Chili peppers / Hot peppers / Poblano, Cayanne Serrano, Habanero, Jalapeño | DE            | Pepper bush (DE)              |                |
	   | Watermelon                                                                 | JT            | Melon vine                    |                |
	   | Honeydew melon                                                             |               | Melon vine                    | CC0            |
	   | Cantaloupe melon                                                           |               | Melon vine                    | CC0            |
	   | Acorn squash                                                               |               | Gourd vine                    | CC0            |
	   | Pumpkin                                                                    | JT            | Gourd vine                    |                |
	   | Crookneck squash                                                           | JT            | Gourd vine                    |                |
	   | Butternut squash                                                           |               | Gourd vine                    | CC0            |
	   | Corn                                                                       | DE            | Corn (DE)                     |                |
	   | Corn                                                                       | DE, JT        | Corn (DE)                     |                |
	   |----------------------------------------------------------------------------|---------------|-------------------------------|----------------|
	   | Asparagus                                                                  |               | Asparagus plant               | CC0            |
	   | Rhubarb                                                                    |               | Rhubarb / chard               | CC0            |
	   | Romaine lettuce                                                            |               | Romaine lettuce               | CC0            |
	   | Iceberg lettuce                                                            | RK            | Iceberg lettuce               |                |
	   | Kale                                                                       |               | Kale                          | CC0            |
	   | Red cabbage / Purple cabbage                                               |               | Cabbage/Cauliflower/Broccoli  | CC0            |
	   | Green cabbage                                                              |               | Cabbage/Cauliflower/Broccoli  | CC0            |
	   | Celery                                                                     |               | Celery                        | CC0            |
	   | Bok choy                                                                   |               | Bok choy                      | CC0            |
	   | Fennel bulb                                                                |               | Fennel plant                  | CC0            |
	   | Brussels sprouts                                                           |               | Brussels sprouts              | CC0            |
	   | Cauliflower                                                                | JT            | Cabbage/Cauliflower/Broccoli  |                |
	   | Broccoli                                                                   | JT            | Cabbage/Cauliflower/Broccoli  |                |
	   | Artichoke                                                                  | DE            | Artichoke plant (DE)          |                |
	   | Leeks                                                                      |               | Onion/Garlic/leek             | CC0            |
	   | Kohlrabi                                                                   |               | Kohlrabi                      | CC0            |
	   | Eggplant                                                                   | DE, JT        | Zucchini/Squash/Cucumber vine |                |
	   | Zucchini / Green squash                                                    | DE            | Zucchini/Squash/Cucumber vine |                |
	   | Yellow squash / Summer squash                                              | DE            | Zucchini/Squash/Cucumber vine |                |
	   | Cucumber                                                                   | RK            | Zucchini/Squash/Cucumber vine |                |
	   | Strawberry                                                                 | JT            | {Black,Straw,Rasp}berry bush  |                |
	   | Blackberries                                                               |               | {Black,Straw,Rasp}berry bush  | CC0            |
	   | Raspberries                                                                |               | {Black,Straw,Rasp}berry bush  | CC0            |
	   | Blueberries                                                                |               | Blueberry bush                | CC0            |
	   | Red grapes                                                                 |               | Grapevine                     | CC0            |
	   | Green grapes                                                               |               | Grapevine                     | CC0            |
	   | Cherry tomatoes                                                            | DE            | Tomato vine (DE)              |                |
	   | Tomatoes                                                                   | DE            | Tomato vine (DE)              |                |
	   | Large tomatoes                                                             | JT            | Tomato vine (DE)              |                |
	   | Peas / Snap peas / Sugar peas                                              | JT            | Pea / green bean vine         |                |
	   | Hops                                                                       |               | Hops vine                     | CC0            |
	   | Green beans                                                                |               | Pea / green bean vine         | CC0            |
	   |----------------------------------------------------------------------------|---------------|-------------------------------|----------------|
	   | Coffee                                                                     |               | Coffee tree                   | CC0            |
	   | Pineapple                                                                  |               | Pineapple plant               | CC0            |
	   | Kiwi                                                                       |               | Kiwi vine                     | CC0            |
	   |----------------------------------------------------------------------------|---------------|-------------------------------|----------------|

4. For the trees:

       "[LPC] Fruit Trees" by bluecarrot16, Joshua Taylor, and cynicmusic. Commissioned by castelonia.
	
       CC-BY-SA 3.0 / GPL 3.0
	
       ## BASED ON:
	
       Fruit and Veggie Inventory
       JT = Joshua Taylor
       CC-BY-SA 3.0 / GPL 3.0
       https://opengameart.org/content/fruit-and-veggie-inventory
	
       Pixelsphere 32x32 Tileset + Grass + Trees
       cynicmusic
       CC0
       http://opengameart.org/content/pixelsphere-32x32-tileset-grass-trees
