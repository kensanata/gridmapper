Gridmapper
==========

A little clojure program to create maps for role-playing games. It is
written using Clojure.

Run it from the command-line:

    clojure gridmapper.clj

Click to draw a tile. Click on a tile toggles it. There are two modes
which you can enter by pressing a key:

`n` enters *normal mode* and it's the default. Clicking a tile will
toggle between the tile and empty space.

`d` enters *door mode*. Clicking a tile will toggle between the tile
and a door, if possible. A door is possible when two opposing sides
are empty and the other two opposing sides contain tiles, ie. we're
looking at a corridor.
