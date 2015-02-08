Gridmapper
==========

A little clojure program to create maps for role-playing games. It is
written using [Clojure](http://clojure.org/). Run it from the
command-line using [Leiningen](http://leiningen.org/). Here is what I
needed to do on my Mac, assuming I already have
[Homebrew](http://brew.sh/) installed.

    brew install leiningen
    git clone git@github.com:kensanata/gridmapper.git
	cd gridmapper
	lein run

Click to draw a tile. Click on a tile toggles it. There are two modes
which you can enter by pressing a key:

`n` enters *normal mode* and it's the default. Clicking a tile will
toggle between the tile and empty space.

`t` enters *trap mode*. Clicking a tile will toggle between the tile
and a trap.

`d` enters *door mode*. Clicking a tile will toggle between the tile
and a door, if possible. A door is possible when two opposing sides
are empty and the other two opposing sides contain tiles, ie. we're
looking at a corridor.

![Screenshot](http://alexschroeder.ch/pics/gridmapper-3.png)

The code was the result of admiring Daniel R. Collins'
[original GridMapper 1.0](http://www.superdan.net/software/gridmapper/)
and me experimenting with Clojure. You can see how it all began
[on my website](http://alexschroeder.ch/wiki/2010-06-10_Clojure_Einf%C3%BChrung)
(in German).

Web App
-------

Note that there is a branch called
[c2](https://github.com/kensanata/gridmapper/tree/c2) which uses
[C2](https://keminglabs.com/c2/) to create a web application.
Unfortunately, it doesn't scale well: when you use a 30×30 grid, it's
too slow.
