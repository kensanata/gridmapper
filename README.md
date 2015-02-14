Gridmapper
==========

Open the [gridmapper.svg](https://campaignwiki.org/gridmapper.svg)
file using your browser and you have a very simple dungeon mapping
tool.

The user interface comes with a help screen explaining all the
details, and a link to a demo.

Also note that it's totally free and gratis. It costs nothing to use,
and you can do with it what you want. Using the appropriate download
link you can save your work to a local file – and the local file comes
with all the code to keep working on it, off line! A bit like
[Tiddly Wiki](http://tiddlywiki.com/), I guess.﻿

Examples
--------

* [Gridmapper Logo](https://campaignwiki.org/gridmapper.svg?%0A%20f%20ss%20f%0A%20s%0A%20%20%20%20sss%0A%20fssss%20%20f)
* [OSR Logo](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftfw.wfwwfww.dddfw%0A%20wfffwnnnn%20nn%20wfwwfwwfw%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww)
* [Demo Dungeon](https://campaignwiki.org/gridmapper.svg?%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffff%20%20%20%20fwfwf%0A%20%20%20%20%20%20%20%20%20%20%20ssss%20%20ffffdfssss%20%20fddfddfddf%24%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffff%20%20%20%20ddfw.dfw.df%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffdfnn%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffnnnn%20fff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20fggf%20%20fffcfff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20ff%20%20%20%20%20ff%24%24%24f%0A%20%20%20%20%20%20%20%20%20%20%20pppff%24f%20%20%20%20fff%0A%20%20%20%20%20%20%20%20%20%20%20btfffwf%0A%20%20%20%20%20%20%20%20%20%20%20pppffwf)

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
