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

5. For the collected / produced foods:

	   "[LPC] Foods" by bluecarrot16, Daniel Eddeland (daneeklu), Joshua Taylor, Richard Kettering (Jetrel), thekingphoenix, RedVoxel, and Molly "Cougarmint" Willits. 
	   https://opengameart.org/content/lpc-food

	   # BASED ON:

	   [LPC] Farming tilesets, magic animations and UI elements
	   DE = Daniel Eddeland (Daneeklu)
	   CC-BY-SA 3.0 / GPL 3.0
	   https://opengameart.org/content/lpc-farming-tilesets-magic-animations-and-ui-elements

	   Fruit and Veggie Inventory
	   JT = Joshua Taylor
	   CC-BY-SA 3.0 / GPL 3.0 
	   https://opengameart.org/content/fruit-and-veggie-inventory

	   RPG item set
	   RK = Richard Kettering (Jetrel)
	   CC0
	   https://opengameart.org/content/rpg-item-set

	   Icons: Food.
	   TKP = thekingphoenix
	   CC0
	   http://opengameart.org/content/icons-food

	   Food Items 16x16
	   RV = RedVoxel
	   CC0
	   https://opengameart.org/content/food-items-16x16

	   Chicken and Pork Icon Pack
	   MCW = Molly "Cougarmint" Willits
	   CC-BY 3.0 / OGA-BY 3.0
	   https://opengameart.org/content/chicken-and-pork-icon-pack

	   LPC style farm animals
	   DE = Daniel Eddeland (Daneeklu)
	   CC-BY 3.0 / GPL 2.0
	   https://opengameart.org/content/lpc-style-farm-animals

	   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  

	   # LIST OF ITEMS AND LICENSES

	   All items edited by bluecarrot16. Original authors listed, otherwise drawn from scratch by bluecarrot16. 

	   - If you use this entire set, the license is CC-BY-SA 3.0+ or GPL v3.0+. 
	   - All individual can be used under either of those licenses (CC-BY-SA 3.0+ or GPL 3.0+). 
	   - Some items can also be used under other licenses, according to the table below.
	   - For items with a CC-BY, CC-BY-SA, OGA-BY, or GPL license, you must credit the original author(s) as well as bluecarrot16, link to the original submissions (above) and include a link back to this page <https://opengameart.org/content/lpc-food>.
	   - For items licensed CC0, credit and link back to this page is appreciated, but not required. 

	   EXAMPLE 1: Watermelon
	   Watermelon, by Joshua Taylor, Richard Kettering (Jetrel), and bluecarrot16.
	   CC-BY-SA 3.0
	   https://opengameart.org/content/lpc-food
	   Based on:
	   https://opengameart.org/content/fruit-and-veggie-inventory
	   https://opengameart.org/content/rpg-item-set


	   EXAMPLE 2: Leeks (credit optional due to CC0 license)
	   Leeks by bluecarrot16
	   CC0
	   https://opengameart.org/content/lpc-food


	   ## PRODUCE

	   ### FRUITS / VEGETABLES

	   |                                        Item                                       | Other Authors | Other Licenses |     |          Family          |          Scientific          |
	   |-----------------------------------------------------------------------------------|---------------|----------------|-----|--------------------------|------------------------------|
	   | Sweet potatoes                                                                    | DE            |                |     | Morning glory            | Convolvulaceae               |
	   | Russet potatoes                                                                   | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Gold potatoes                                                                     | DE            |                |     | Nightshade               | Solanaceae                   |
	   | Purple potatoes                                                                   | DE            |                |     | Nightshade               | Solanaceae                   |
	   | Cherry tomatoes                                                                   |               |                |     | Nightshade               | Solanaceae                   |
	   | Tomatoes                                                                          | DE            |                |     | Nightshade               | Solanaceae                   |
	   | Large tomatoes                                                                    | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Golden berry / cape gooseberry / Uchuva                                           |               | CC0            | V2  | Nightshade               | Solanaceae                   |
	   | Naranjilla                                                                        |               | CC0            | V2  | Nightshade               | Solanaceae                   |
	   | Eggplant                                                                          | DE, JT        |                |     | Nightshade               | Solanaceae                   |
	   | Poblano pepper / chile ancho                                                      | DE            |                | V2  | Nightshade               | Solanaceae                   |
	   | Hot pepper                                                                        | DE            |                |     | Nightshade               | Solanaceae                   |
	   | Green bell pepper                                                                 | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Red bell pepper                                                                   | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Orange bell pepper                                                                | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Yellow bell pepper                                                                | JT            |                |     | Nightshade               | Solanaceae                   |
	   | Mixed Chili peppers / Hot peppers / Poblano, Cayenne, Serrano, Habanero, Jalapeño |               | CC0            |     | Nightshade               | Solanaceae                   |
	   | Jalapeño pepper                                                                   |               |                | V2  | Nightshade               | Solanaceae                   |
	   | Habanero / Scotch Bonnet pepper                                                   |               |                | V2  | Nightshade               | Solanaceae                   |
	   | Cayenne pepper                                                                    |               |                | V2  | Nightshade               | Solanaceae                   |
	   | Madame Jeanette / Yellow pepper                                                   |               |                | V2  | Nightshade               | Solanaceae                   |
	   | Cubanelle pepper                                                                  |               |                | V2  | Nightshade               | Solanaceae                   |
	   | Watermelon                                                                        | JT, RK        |                |     | Gourd                    | Cucurbitaceae                |
	   | Honeydew melon                                                                    |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   | Cantaloupe melon                                                                  |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   | Kiwano melon / Horned melon                                                       |               | CC0            | V2  | Gourd                    | Cucurbitaceae                |
	   | Delicata squash                                                                   |               | CC0            | V2  | Gourd                    | Cucurbitaceae                |
	   | Acorn squash                                                                      |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   | Pumpkin                                                                           | JT            |                |     | Gourd                    | Cucurbitaceae                |
	   | Crookneck squash                                                                  | JT            |                |     | Gourd                    | Cucurbitaceae                |
	   | Butternut squash                                                                  |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   | Ornamental gourds: turban squash, gooseneck, small pumpkins                       |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   |-----------------------------------------------------------------------------------|---------------|----------------|-----|--------------------------|------------------------------|
	   | Romaine lettuce                                                                   |               | CC0            |     | Daisy                    | Asteraceae                   |
	   | Iceberg lettuce                                                                   | RK            | CC0            |     | Daisy                    | Asteraceae                   |
	   | Radicchio                                                                         |               | CC0            | V2  | Daisy                    | Asteraceae                   |
	   | Artichoke                                                                         | DE            |                |     | Daisy                    | Asteraceae                   |
	   | Tarragon                                                                          |               | CC0            | V2  | Daisy                    | Asteraceae                   |
	   | Cardoon / Burdock / Artichoke thustle                                             |               | CC0            | V2  | Daisy                    | Asteraceae                   |
	   | Burdock root / Cardoon root                                                       |               | CC0            | V2  | Daisy                    | Asteraceae                   |
	   | Chamomile / camomile                                                              |               | CC0            | V2  | Daisy                    | Asteraceae                   |
	   | Lacinato kale / Tuscan kale / Dinosaur kale                                       |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Kale                                                                              |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Red cabbage / Purple cabbage                                                      |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Green cabbage                                                                     |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Bok choy                                                                          |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Brussels sprouts                                                                  |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Cauliflower                                                                       | JT            |                |     | Crucifers                | Brassicaceae                 |
	   | Broccoli                                                                          | JT            |                |     | Crucifers                | Brassicaceae                 |
	   | Broccoli rabe / Broccolini                                                        |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Kohlrabi                                                                          |               | CC0            |     | Crucifers                | Brassicaceae                 |
	   | Radishes                                                                          | JT            |                |     | Crucifers                | Brassicaceae                 |
	   | Daikon Radishes                                                                   | DE            |                | V2  | Crucifers                | Brassicaceae                 |
	   | Turnips                                                                           | JT            |                |     | Crucifers                | Brassicaceae                 |
	   | Rutabaga / Swede                                                                  | JT            |                |     | Crucifers                | Brassicaceae                 |
	   | Arugula / Rocket / Eruca                                                          |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Mugwort / Artemisia                                                               |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Romanesco broccoli / Roman cauliflower                                            |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Cress                                                                             |               | CC0            | V2  | Crucifers                | Brassicaceae                 |
	   | Chayote                                                                           |               | CC0            | V2  | Gourd                    | Cucurbitaceae                |
	   | Zucchini / Green squash                                                           | DE            |                |     | Gourd                    | Cucurbitaceae                |
	   | Yellow squash / Summer squash                                                     | DE            |                |     | Gourd                    | Cucurbitaceae                |
	   | Cucumber                                                                          | RK            | CC0            |     | Gourd                    | Cucurbitaceae                |
	   | Pepino dulce                                                                      |               | CC0            | V2  | Gourd                    | Cucurbitaceae                |
	   | Ornamental gourds: pan patty squash, small pumpkins                               |               | CC0            |     | Gourd                    | Cucurbitaceae                |
	   |-----------------------------------------------------------------------------------|---------------|----------------|-----|--------------------------|------------------------------|
	   | Peas / Snap peas / Sugar peas                                                     | JT            |                |     | Bean                     | Fabaceae                     |
	   | Green beans                                                                       |               | CC0            |     | Bean                     | Fabaceae                     |
	   | Soybeans                                                                          |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Black beans                                                                       |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Chickpeas / Garbanzo beans                                                        |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Kidney beans                                                                      |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Black-eyed peas                                                                   |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Pinto beans                                                                       |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Navy beans / White beans                                                          |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Coffee                                                                            |               | CC0            |     | Bean                     | Fabaceae                     |
	   | Black lentils                                                                     |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Green lentils                                                                     |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Red lentils                                                                       |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Yellow lentils                                                                    |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Peanuts                                                                           |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Fenugreek                                                                         |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Licorice root                                                                     |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Jicama / Mexican yam bean / Mexican turnip                                        | JT            |                | V2  | Bean                     | Fabaceae                     |
	   | Lemongrass                                                                        |               | CC0            | V2  | Bean                     | Fabaceae                     |
	   | Lotus root                                                                        |               | CC0            | V2  | Lotus                    | Nelumbonaceae                |
	   | Taro root                                                                         |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Bamboo                                                                            |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Rice                                                                              |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Oats                                                                              |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Barley                                                                            |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Rye                                                                               |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Wheat                                                                             |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Quinoa                                                                            |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Corn                                                                              | DE            |                |     | Grass                    | Poaceae                      |
	   | Corn                                                                              | JT            |                |     | Grass                    | Poaceae                      |
	   | Sugar cane                                                                        |               | CC0            | V2  | Grass                    | Poaceae                      |
	   | Amaranth                                                                          |               | CC0            | V2  | Amaranth                 | Amaranthaceae                |
	   |-----------------------------------------------------------------------------------|---------------|----------------|-----|--------------------------|------------------------------|
	   | Asparagus                                                                         |               | CC0            |     | Asparagus                | Asparagaceae                 |
	   | Agave / Maguey                                                                    |               | CC0            | V2  | Asparagus                | Asparagaceae                 |
	   | Aloe                                                                              |               | CC0            | V2  |                          | Asphodelaceae                |
	   | Nori                                                                              |               | CC0            | V2  | Algae                    |                              |
	   | Fiddlehead                                                                        |               | CC0            | V2  | Fern                     |                              |
	   | Nopal / Prickly pear cactus                                                       |               | CC0            | V2  | Cactaceae                |                              |
	   | Basil                                                                             |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Oregano                                                                           |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Lavender                                                                          |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Mint                                                                              |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Sage                                                                              |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Rosemary                                                                          |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Thyme                                                                             |               |                | V2  | Mint / Deadnettle / Sage | Lamiaceae                    |
	   | Pineapple                                                                         |               | CC0            |     |                          | Bromeliaceae                 |
	   | Kiwi / Kiwifruit                                                                  |               | CC0            |     | Chinese gooseberry       | Actinidiaceae, Ericales      |
	   | Yuca / Cassava                                                                    | DE            |                |     |                          | Euphorbiaceae, Malpighiales  |
	   | Passionfruit                                                                      |               |                | V2  |                          | Passifloraceae, Malpighiales |
	   | Beets                                                                             | JT            |                |     | Amaranth                 | Amaranthaceae                |
	   | Spinach                                                                           |               | CC0            | V2  | Amaranth                 | Amaranthaceae                |
	   | Chard, red                                                                        |               |                | V2  | Amaranth                 | Amaranthaceae                |
	   | Chard, yellow                                                                     |               |                | V2  | Amaranth                 | Amaranthaceae                |
	   | Sugarbeet                                                                         | DE            |                | V2  | Amaranth                 | Amaranthaceae                |
	   | Vanilla                                                                           |               | CC0            | V2  | Orchid                   | Orchidaceae                  |
	   | Saffron                                                                           |               | CC0            | V2  |                          | Iridaceae, Asparagales       |
	   | Garlic                                                                            | JT            |                |     | Onion                    | Amaryllidaceae               |
	   | Yellow onion / Sweet onion                                                        | JT            |                |     | Onion                    | Amaryllidaceae               |
	   | Red onion / Purple onion                                                          | JT            |                |     | Onion                    | Amaryllidaceae               |
	   | White onion                                                                       | JT            |                |     | Onion                    | Amaryllidaceae               |
	   | Green onion                                                                       | JT            |                |     | Onion                    | Amaryllidaceae               |
	   | Leeks                                                                             |               | CC0            |     | Onion                    | Amaryllidaceae               |
	   | Chives                                                                            |               | CC0            | V2  | Onion                    | Amaryllidaceae               |
	   | Rhubarb                                                                           |               | CC0            |     | Buckwheat                | Polygonaceae                 |
	   |-----------------------------------------------------------------------------------|---------------|----------------|-----|--------------------------|------------------------------|
	   | Strawberry                                                                        | JT            |                |     |                          | Rosaceae                     |
	   | Blackberries                                                                      |               | CC0            |     |                          | Rosaceae                     |
	   | Raspberries                                                                       |               | CC0            |     |                          | Rosaceae                     |
	   | Blueberries                                                                       |               | CC0            | V2* | Heath / Heather          | Ericaceae,  Ericales         |
	   | Cranberries                                                                       |               | CC0            | V2  | Heath / Heather          | Ericaceae,  Ericales         |
	   | Elderberries                                                                      |               | CC0            | V2  | Moschatel                | Adoxaceae                    |
	   | Mulberries                                                                        |               | CC0            | V2  | Fig                      | Moraceae                     |
	   | Gooseberry                                                                        |               | CC0            | V2  | Gooseberry               | Grossulariaceae              |
	   | Red grapes                                                                        |               | CC0            | V2  | Grape                    | Vitaceae                     |
	   | Black grapes                                                                      |               | CC0            | V2  | Grape                    | Vitaceae                     |
	   | Purple grapes                                                                     |               | CC0            | V2* | Grap                     | Vitaceae                     |
	   | Green grapes                                                                      |               | CC0            | V2* | Grape                    | Vitaceae                     |
	   | Ginger                                                                            |               | CC0            | V2  | Ginger                   | Zingiberaceae                |
	   | Turmeric                                                                          |               | CC0            | V2  | Ginger                   | Zingiberaceae                |
	   | Ginseng                                                                           |               | CC0            | V2  |                          | Araliaceae                   |
	   | Horseradish                                                                       |               | CC0            | V2  | Cabbage                  | Brassicaceae                 |
	   | Wasabi                                                                            |               | CC0            | V2  | Cabbage                  | Brassicaceae                 |
	   | Mustard                                                                           |               | CC0            | V2  | Cabbage                  | Brassicaceae                 |
	   | Sesame                                                                            |               | CC0            | V2  |                          | Pedaliaceae                  |
	   | Hops                                                                              |               | CC0            |     | Cannabis                 | Cannabaceae                  |
	   | Cotton                                                                            |               | CC0            | V2  | Mallow                   | Malvaceae                    |
	   | Okra                                                                              |               | CC0            | V2  | Mallow                   | Malvaceae                    |
	   | Black tea leaves                                                                  |               | CC0            | V2  | Tea                      | Theaceae, Ericales           |
	   | Green tea leaves                                                                  |               | CC0            | V2  | Tea                      | Theaceae, Ericales           |
	   | Carrots                                                                           | JT            |                |     | Carrot                   | Apiaceae                     |
	   | Parsnips                                                                          | JT            |                |     | Carrot                   | Apiaceae                     |
	   | Fennel bulb                                                                       |               | CC0            | V2* | Carrot                   | Apiaceae                     |
	   | Parsley                                                                           |               | CC0            | V2  | Carrot                   | Apiaceae                     |
	   | Celery                                                                            |               | CC0            | V2* | Carrot                   | Apiaceae                     |
	   | Cilantro                                                                          |               | CC0            | V2  | Carrot                   | Apiaceae                     |
	   | Dill                                                                              |               |                | V2  | Carrot                   | Apiaceae                     |
	   | Cumin                                                                             |               |                | V2  | Carrot                   | Apiaceae                     |

	   ### MUSHROOMS

	   |                                    Item                                    | Other Authors | Other Licenses |    |
	   |----------------------------------------------------------------------------|---------------|----------------|----|
	   | Shiitake                                                                   |               | CC0            | V2 |
	   | Common mushroom / button mushroom / crimini mushroom / champignon mushroom |               | CC0            |    |
	   | Oyster mushrooms                                                           |               | CC0            |    |
	   | Sulfur shelf mushrooms / Laetiporus / Chicken of the Woods                 |               | CC0            | V2 |
	   | Maitake / Ram's head                                                       |               | CC0            | V2 |
	   | Chanterelle mushrooms                                                      |               | CC0            | V2 |
	   | Portobello mushrooms                                                       |               | CC0            |    |
	   | King trumpet mushrooms / King oyster mushrooms / French horn mushroom      |               | CC0            |    |
	   | Black morels                                                               |               | CC0            |    |
	   | Enokitake / Enoki                                                          |               | CC0            |    |

	   ### FRUITS

	   |                   Item                   | Other Authors | Other Licenses |     |          Family         |       Scientific       |
	   |------------------------------------------|---------------|----------------|-----|-------------------------|------------------------|
	   | Red delicious apples / red apples        | JT            |                |     | Rose                    | Rosaceae               |
	   | Granny smith apples / green apples       | JT            |                |     | Rose                    | Rosaceae               |
	   | Golden delicious apples / yellow apples  | JT            |                |     | Rose                    | Rosaceae               |
	   | Golden delicious apples / yellow apples  | JT            |                |     | Rose                    | Rosaceae               |
	   | Honeycrisp apples / variegated apples    | JT            |                |     | Rose                    | Rosaceae               |
	   | Bartlett pears / Green pears             | JT            |                |     | Rose                    | Rosaceae               |
	   | D'anjou pears / Yellow pears             | JT            |                |     | Rose                    | Rosaceae               |
	   | Bosc pears / Brown pears                 | JT            |                |     | Rose                    | Rosaceae               |
	   | Cherries                                 | JT            |                |     | Rose                    | Rosaceae               |
	   | Apricots                                 |               |                | V2  | Rose                    | Rosaceae               |
	   | Peaches                                  |               | CC0            | V2* | Rose                    | Rosaceae               |
	   | Almond                                   |               | CC0            |     | Rose                    | Rosaceae               |
	   | Plums                                    |               | CC0            |     | Rose                    | Rosaceae               |
	   | Tangerines / Mandarin oranges / Kumquats |               | CC0            |     | Citrus                  | Rutaceae               |
	   | Oranges                                  | JT            |                |     | Citrus                  | Rutaceae               |
	   | Grapefruit                               | JT            |                | V2  | Citrus                  | Rutaceae               |
	   | Yuzu                                     |               | CC0            | V2  | Citrus                  | Rutaceae               |
	   | Lemon                                    | JT            |                | V2* | Citrus                  | Rutaceae               |
	   | Lime                                     | JT            |                | V2* | Citrus                  | Rutacea                |
	   | Pomegranate                              |               | CC0            |     |                         | Lythraceae, Myrtales   |
	   | Olives                                   |               | CC0            | V2  | Olive                   | Oleaceae               |
	   | Starfruit / Carambola                    |               | CC0            |     |                         | Oxalidaceae            |
	   | Poppy                                    |               | CC0            | V2  | Poppy                   | Papaveraceae           |
	   | Cherimoya                                |               |                |     | Custard apple / Soursop | Annonaceae, Magnoliids |
	   | Soursop / Graviola                       |               | CC0            | V2  | Custard apple / Soursop | Annonaceae, Magnoliids |
	   | Figs                                     |               | CC0            |     | Fig                     | Moraceae               |
	   | Jackfruit / Jack tree                    |               | CC0            |     | Fig                     | Moraceae               |
	   | Breadfruit                               |               | CC0            |     | Fig                     | Moraceae               |
	   | Papaya                                   |               | CC0            |     |                         | Caricaceae             |
	   | Dragonfruit / Pitaya / Pitahaya          |               | CC0            | V2  | Cactus                  | Cactaceae              |
	   | Rambutan                                 |               | CC0            | V2  | Soapberry               | Sapindaceae            |
	   | Lychee                                   |               | CC0            | V2  | Soapberry               | Sapindaceae            |
	   |------------------------------------------|---------------|----------------|-----|-------------------------|------------------------|
	   | Banana                                   | JT            |                | V2* | Banana                  | Musaceae               |
	   | Poovan banana                            | JT            |                | V2  | Banana                  | Musaceae               |
	   | Red banana                               | JT            |                | V2  | Banana                  | Musaceae               |
	   | Plantain                                 |               |                | v2  | Banana                  | Musaceae               |
	   | Coconut                                  |               | CC0            | V2  | Palm                    | Arecaceae              |
	   | Date                                     |               | CC0            | V2  | Palm                    | Arecaceae              |
	   | Heart of Palm                            |               | CC0            | V2  | Palm                    | Arecaceae              |
	   | Acai                                     |               | CC0            | V2  | Palm                    | Arecaceae              |
	   | Juniper                                  |               | CC0            | V2  | Cypress                 | Cupressaceae           |
	   | Bay laurel                               |               | CC0            | V2  | Laurel                  | Lauraceae              |
	   | Cinammon                                 |               | CC0            | V2  | Laurel                  | Lauraceae              |
	   | Avocado                                  |               | CC0            | V2  | Laurel                  | Lauraceae              |
	   | Poppy                                    |               | CC0            | V2  |                         | Papaveraceae           |
	   | Nutmeg                                   |               | CC0            | V2  | Magnolia                | Magnoliids             |
	   | Peppercorn                               |               | CC0            | V2  | Magnolia                | Magnoliids             |
	   | Brazil nut                               |               | CC0            | V2  |                         | Ericales               |
	   | Persimmon                                |               | CC0            | V2  |                         | Ericales               |
	   | Guava                                    |               | CC0            | V2  | Myrtles                 | Myrtaceae              |
	   | Clove                                    |               | CC0            | V2  | Myrtles                 | Myrtaceae              |
	   | Allspice                                 |               | CC0            | V2  | Myrtles                 | Myrtaceae              |
	   | Kola                                     |               | CC0            | V2  | Mallow                  | Malvaceae              |
	   | Durian                                   |               | CC0            | V2  | Mallow                  | Malvaceae              |
	   | Cacao                                    |               | CC0            | V2  | Mallow                  | Malvaceae              |
	   | Mango                                    |               | CC0            |     | Cashew / Sumac          | Anacardiaceae          |
	   | Mango                                    |               | CC0            |     | Cashew / Sumac          | Anacardiaceae          |
	   | Pistachio                                |               | CC0            |     | Cashew / Sumac          | Anacardiaceae          |
	   | Sumac                                    |               | CC0            | V2  | Cashew / Sumac          | Anacardiaceae          |
	   | Cashew                                   |               | CC0            |     | Cashew / Sumac          | Anacardiaceae          |
	   | Chestnut                                 |               | CC0            | V2  | Beech                   | Fagales, Fagaceae      |
	   | Pecan                                    |               | CC0            |     | Beech                   | Fagales, Juglandaceae  |
	   | Walnut                                   |               | CC0            |     | Walnut                  | Fagales, Juglandaceae  |
	   | Macademia                                |               | CC0            |     |                         | Proteaceae             |
	   | Tamarind                                 |               | CC0            |     | Bean                    | Fabaceae               |


	   ## BAKED GOODS & CEREAL PRODUCTS

	   ### BREAD

	   |            Item            | Other Authors | Other Licenses |
	   |----------------------------|---------------|----------------|
	   | Vienna small               | RV            | CC0            |
	   | Loaf / White bread         | RK            | CC0            |
	   | Vienna large               | TKP           | CC0            |
	   | Baguette                   |               | CC0            |
	   | Pullman loaf / Rye         |               | CC0            |
	   | Coburg large               |               | CC0            |
	   | ???                        |               | CC0            |
	   | ???                        |               | CC0            |
	   | Braided                    |               | CC0            |
	   | Ciabatta                   |               | CC0            |
	   | Crossed                    |               | CC0            |
	   | Crossed 2                  |               | CC0            |
	   | Focaccia                   |               | CC0            |
	   | Braided                    |               | CC0            |
	   | Breadsticks                |               | CC0            |
	   | Tortillas                  |               | CC0            |
	   |----------------------------|---------------|----------------|
	   | English Muffin             |               | CC0            |
	   | Kaiser roll                |               | CC0            |
	   | Sesame bun / Hamburger bun |               | CC0            |
	   | Crescent roll              |               | CC0            |
	   | Coburg roll                |               | CC0            |
	   | Muffin                     |               | CC0            |
	   | Cob / Boule roll           |               | CC0            |
	   | Pretzel                    |               | CC0            |
	   | Croissant                  |               | CC0            |
	   | Bagel                      |               | CC0            |
	   |----------------------------|---------------|----------------|
	   | Chocolate cake             |               | CC0            |
	   | Pie                        |               | CC0            |
	   | Braided Pie                |               | CC0            |
	   | Pancakes                   |               | CC0            |
	   | Waffles                    |               | CC0            |
	   | Donut                      |               | CC0            |


	   ## ANIMAL PRODUCTS

	   ### CHEESE, DAIRY, EGGS

	   |           Item           | Other Authors | Other Licenses |
	   |--------------------------|---------------|----------------|
	   | Brie                     | TKP           | CC0            |
	   | Gouda                    | TKP           | CC0            |
	   | White Swiss              | TKP           | CC0            |
	   | Cheddar                  | TKP           | CC0            |
	   | Yellow Swiss             | TKP           | CC0            |
	   | Smoked gruyere           |               | CC0            |
	   | Muenster                 |               | CC0            |
	   | Blue cheese / Gorgonzola | TKP           | CC0            |
	   | Feta                     |               | CC0            |
	   | Mozarella                |               | CC0            |
	   | Manchengo                |               | CC0            |
	   | Jack                     |               | CC0            |
	   | Parmesean                |               | CC0            |
	   |--------------------------|---------------|----------------|
	   | White eggs               |               | CC0            |
	   | Brown eggs               |               | CC0            |
	   | Hardboiled eggs          |               | CC0            |
	   | Fried eggs               |               | CC0            |
	   | Scrambled eggs           |               | CC0            |
	   | Butter                   |               | CC0            |

	   ### MEAT

	   |           Item          | Other Authors |     Other Licenses     |
	   |-------------------------|---------------|------------------------|
	   | Chicken                 | MCW           | CC-BY 3 / OGA-BY 3     |
	   | Chicken drumstick       | RK            | CC0                    |
	   | Rotisserie chicken      | DE            |                        |
	   | Large chicken drumstick | DE            |                        |
	   | Turkey                  | DE            |                        |
	   | Chicken breast          | DE            |                        |
	   | Chicken breast, medium  | DE            |                        |
	   | Chicken breast, small   | DE            |                        |
	   | Chop                    | RK            | CC0                    |
	   | Sausage                 | RK            | CC0                    |
	   | Ribeye steak            | DE            |                        |
	   | Ribeye steak, small     | DE            |                        |
	   | T-bone steak            |               | CC0                    |
	   | Rib roast               |               | CC0                    |
	   | Sliced rib roast        |               | CC0                    |
	   | Back ribs               |               | CC0                    |
	   | Ham                     | DE            |                        |
	   | Pork chop               | MCW           | CC-BY 3.0 / OGA-BY 3.0 |
	   | Pork chop, small        |               | CC0                    |
	   | Bacon                   |               | CC0                    |
	   | Lamb chop               |               |                        |
	   | Kebab                   |               | CC0                    |
	   | Meatballs               |               | CC0                    |
	   | Pig                     | DE            |                        |

	   ### SEAFOOD

	   |    Item   | Other Authors | Other Licenses |
	   |-----------|---------------|----------------|
	   | Mussel    |               | CC0            |
	   | Scallop   |               | CC0            |
	   | Oyster    |               | CC0            |
	   | Crab      |               | CC0            |
	   |-----------|---------------|----------------|
	   | Anchovy   |               | CC0            |
	   | Perch     | DE            |                |
	   | Salmon    | DE            |                |
	   | Trout     | DE            |                |
	   | Catfish   | DE            |                |
	   | Walleye   | DE            |                |
	   | Carp      | DE            |                |
	   | Bass      |               | CC0            |
	   | Flounder  |               | CC0            |
	   | Cod       | DE            |                |
	   | Tilapia   |               | CC0            |
	   | Herring   |               | CC0            |
	   | Haddock   |               | CC0            |
	   | Calamari  |               | CC0            |
	   | Lobster   |               | CC0            |
	   |-----------|---------------|----------------|
	   | Grouper   | DE            |                |
	   | Halibut   |               | CC0            |
	   | Tuna      | DE            |                |
	   | Swordfish |               | CC0            |
	   | Pike      | DE            |                |
