This is the description for a Mansion visual. A Mansion, literally, stands for a big house
in this context, and this one in particular uses victorian / post-victorian styles.

There is a file which is the source of everything:

res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/mansion.png

You'll notice the _SOURCE_TEXTURE of the .Base real-estate class. It is reachable because
the mansion inherits like this:

```gdscript
@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Base
```

So the goal is to always make use of the features there.

What I'm needing to you is that you generate the object like you did in many other objects,
but this one is REALLY complex and has MANY properties. Notice that mansion.gd already has
some of the code implemented. That code is INCOMPLETE and may even be wrong, but take it as
a guideline and keep what you feel that works, related to what I'll write now.

So the goal of a Mansion is to render a very big texture. However, this visual is STATIC.
You'll notice that a mansion is expressed in terms of blocks of 96x96 square pixels. So when
I describe the layout, there are in terms of blocks of 96x96.

So everything starts with the mansion's design, height, wall color and roof color.

- The height of a mansion can be 1 or 2 stories. No more. No less.
- The color of a mansion can be red, blue, green, yellow, purple, and a grayed blue, like
  it's worn liteblue or so.
- The roof has also its own color (10 colors are supported).
- Also, the mansion can have depth (the depth is 1 or 2 and will be explained later).

Before continuing, let's consider what the designs look like in the final texture. Let the
following code:

- R stands for a roof block (remember that each block is 96x96).
- 1 stands for a block on the 1st floor.
- D stands for the block on the 1st floor that has a door. For all the other effects, it
  is a block like `1`.
- 2 stands for a block on the 2nd floor, when 2nd floor is a thing.
- E stands for a block with no design. I'm just adding it for clarity, to fill spaces.

So the designs are like this:

- Linear, 1 story, depth 1:

```
RRR
1D1
```

- Linear, 2 stories, depth 1:

```
RRR
222
1D1
```

- T, 1 story, depth 1:

```
RRR
1R1
EDE
```

- T, 2 stories, depth 1:

```
RRR
2R2
121
EDE
```

- Little C, 1 story, depth 1:

```
RRR
RDR
1E1
```

- Little C, 2 stories, depth 1:

```
RRR
R2R
2D2
1E1
```

- Big C, 1 story, depth 1:

```
RRRRR
R1D1R
1EEE1
```

- Big C, 2 stories, depth 1:

```
RRRRR
R222R
21D12
1EEE1
```

- E, 1 story, depth 1:

```
RRRRR
R1R1R
1EDE1
```

- E, 2 stories, depth 1:

```
RRRRR
R2R2R
21212
1EDE1
```

The dimensions of these textures will be up to 480x384, naively (at least, for the
case of E-design with 2 stories - properly compute [96*x]x[96*y] for each of these
designs). However, add an extra amount of 16px vertically (for a total of 480x400
for the E design with 2 stories).

Now, there's the case of depth=2. Aesthetically, this involves adding more roof:

- Linear, 1 story, depth 2:

```
RRR
RRR
1D1
```

- Linear, 2 stories, depth 2:

```
RRR
RRR
222
1D1
```

- T, 1 story, depth 2:

```
RRR
RRR
1R1
EDE
```

- T, 2 stories, depth 2:

```
RRR
RRR
2R2
121
EDE
```

- Little C, 1 story, depth 2:

```
RRR
RRR
RDR
1E1
```

- Little C, 2 stories, depth 2:

```
RRR
RRR
R2R
2D2
1E1
```

- Big C, 1 story, depth 2:

```
RRRRR
RRRRR
R1D1R
1EEE1
```

- Big C, 2 stories, depth 2:

```
RRRRR
RRRRR
R222R
21D12
1EEE1
```

- E, 1 story, depth 2:

```
RRRRR
RRRRR
R1R1R
1EDE1
```

- E, 2 stories, depth 2:

```
RRRRR
RRRRR
R2R2R
21212
1EDE1
```

Here, the max. dimensions of a texture in pixels are 480x496, following the same
guidelines discussed previously.

The offset is, always, -96px * N, where N is the number of stories.

Now, it's time to understand how the 1, 2, D and R blocks are filled, since those
blocks are not regular (e.g. not all the R blocks use the exact same pattern). This
will be described next, and in tandem with more properties.

1. Finding the roofs.

   This starts by understanding where the roofs are in the texture:

   Start with coordinates (0, 1408). Roof parts are stored in blocks of 96x96. However,
   for each color, 9 different blocks of textures exist to assemble the roof. This means
   that, in practice, each roof color occupies a square of 288x288 pixels.

   The roof colors are: PURPLE, GRAY, BLUE, GREEN, RED, BROWN, WHITE, BLACK, WORN_RED and
   WORN_GREEN, and each square starts at (RXS, RYS) = (0 + 288*A, 1408 + 288*B), where the
   respective (A, B) values are:

   (0, 0) (1, 0) (2, 0) (3, 0) (4, 0) (0, 1) (1, 1) (2, 1) (3, 1) (4, 1)

   With this in mind, (RXS, RYS) will be used as pivots for the roofs.

2. Finding the walls.

   This starts by understanding where the walls are in the texture:

   Start with coordinates (0, 0). Walls are also stored in blocks of 96x96. However, for
   each color, different blocks exist. I'll detail them later. For now, bear in mind that
   you will get the starting point like this: (WXS, WYS) = (0, 192*A) where the respective
   A values are (for colors: YELLOW, RED, GREEN, GRAYBLUE, BLUE, PURPLE):

   0 1 2 3 4 5

   Then, inside each macro-block, the following blocks are used:

   - 1st Floor's bricked: (WXS + 96, WYS + 96)
   - 2nd Floor's bricked: (WXS + 0, WYS + 0)
   - Plain: (WXS + 0, WYS + 96)
   - Columns: (WXS + 192, WYS)
   - Bevel: (WXS + 288, WYS)
