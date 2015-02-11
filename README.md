Gridmapper
==========

Open the [gridmapper.svg](https://campaignwiki.org/gridmapper.svg)
file using your browser and you have a very simple dungeon mapping
tool.

If you click into the empty space and move your mouse, you will be
drawing dungeon floor tiles. If you click on a dungeon floor tile and
move your mouse, you will be erasing them instead.

`d` draws a door on the left edge. If you press `d` again within two
seconds, the door moves to the upper edge, then on to the right edge
and finally to the bottom edge. To add more doors, just wait two
seconds before hitting `d` again. Use `W` to remove features on walls
like doors.

`s` draws a secret door instead of a door. It works exactly the same
in all other aspects.

`c` draws a concealed door instead of a door. It works exactly the
same in all other aspects.

`g` draws a double width gate instead of a door. It works exactly the
same in all other aspects. Rotating it is a bit confusing because of
its double width.

`t` draws a trap door. Hitting `t` again replaces the trap door with
an empty dungeon floor tile.

`l` draws some stairs. If you press `l` again, the stairs are rotated
by 90°. Use `L` to remove the stairs.

`u` will undo an action. `r` will redo the action.

In order to save the file, click on the _Prepare Download_ link. The
_Prepare Download_ link will change to a _Download_ link. Click it and
save the file. If it looks as if nothing changed (if you're using
Firefox, for example), no problem: If you save the file, you'll save
the state of the map it had when you clicked the _Download_ link. The
_Download_ link will revert back to _Prepare Download_ after ten
seconds.

See Also
--------

The project was the result of admiring Daniel R. Collins' [original
GridMapper 1.0](http://www.superdan.net/software/gridmapper/).

This originally started as a Clojure project. You can find the Clojure
code on the
[clojure](https://github.com/kensanata/gridmapper/tree/clojure)
branch.

There is also a branch called
[c2](https://github.com/kensanata/gridmapper/tree/c2) which uses
[C2](https://keminglabs.com/c2/) to create a web application.
Unfortunately, it doesn't scale well: when you use a 30×30 grid, it's
too slow. I decided to move to [VanillaJS](http://vanilla-js.com/).

There's also a very good looking, Flash based website with a similar
interface called [ANAmap](http://deepnight.net/anamap/).
