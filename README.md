Gridmapper
==========

Open the [gridmapper.svg](https://campaignwiki.org/gridmapper.svg)
file using your browser and you have a very simple dungeon mapping
tool.

The user interface comes with a help screen explaining all the
details, and a link to a demo.

Also note that it’s totally free and gratis. It costs nothing to use,
and you can do with it what you want. Using the appropriate download
link you can save your work to a local file – and the local file comes
with all the code to keep working on it, off line! A bit like
[Tiddly Wiki](http://tiddlywiki.com/), I guess.﻿

Written using [Vanilla JS](http://vanilla-js.com/).

Examples
--------

* [Gridmapper Logo](https://campaignwiki.org/gridmapper.svg?%0A%20f%20ss%20f%0A%20s%0A%20%20%20%20sss%0A%20fssss%20%20f)
* [OSR Logo](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftfw.wfwwfww.dddfw%0A%20wfffwnnnn%20nn%20wfwwfwwfw%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww)
* [Demo Dungeon](https://campaignwiki.org/gridmapper.svg?%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20fwfwf%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%206fddfddfddf%24%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20ddfw.dfw.dfz%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffff%0A%20%20%20%20%20%20%20%20%20%20%20ssss%20%20ff1ffdffssssv%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffdfnn%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffnnnn%20fff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20fggf%20%20%204ffcfff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20ff%20%20%20%20%20f5f%24%24%24f%0A%20%20%20%20%20%20%20%20%20%20%20pppff%24f%20%20%20%20fff%0A%20%20%20%20%20%20%20%20%20%20%20btf2ffwf%0A%20%20%20%20%20%20%20%20%20%20%20pppffwf)

You will have noticed that those example URLs contain a lot of
gibberish past the questionmark. This is the URL’s *query string*.
It’s a sort of code that’s very close to a stream of keyboard
commands. You can get this link by clicking on *Prepare Link* and then
clicking on the resulting *Link*. Perfect for sharing and bookmarking.

How to Save
-----------

This being a very simple web application, it has no access to your
file system. And worse: If you use "Save As..." you’ll save a copy
*without* all your changes!

There are two ways to save your creation:

1. Click on **Prepare Link** and then click on the resulting *Link*.
   Bookmark this page. The link now basically contains a little script
   recreating your dungeon.

2. Click on **Prepare Download** and the click on the resulting
   *Download*. On **Firefox**, this will download a copy of Gridmapper
   containing the current state of your dungeon. On **Chrome**, this will
   *open* a copy of Gridmapper containing the current state of your
   dungeon. *Now* you can use "Save As..." On **IE** this won’t work.
   Yikes!

Upgrading your local copy of Gridmapper
---------------------------------------

Let’s assume you downloaded a copy of Gridmapper and started creating
your dungeon. Then you discovered that there’s a new release out
there. How can you upgrade your local file? The **Link URL** is key!

You can get this **Link URL** by loading your local copy, clicking on
*Prepare Link* and then clicking on the resulting *Link*. Here’s a
simple example: ```file:///Users/alex/Documents/awesome.svg?%0A%20s%0A%0A%20ff%0A%20ff```

You can take the part starting with the question mark and use it with
a newer copy of Gridmapper! Download a new copy, load it, and append
the stuff starting with the question mark.
Here’s a simple example: ```file:///Users/alex/Download/gridmapper.svg?%0A%20s%0A%0A%20ff%0A%20ff```

This also works with the Campaign Wiki’s
Gridmapper: ```https://campaignwiki.org/gridmapper.svg?%0A%20s%0A%0A%20ff%0A%20ff```.
[Verify it](https://campaignwiki.org/gridmapper.svg?%0A%20s%0A%0A%20ff%0A%20ff).

Once you have your map in the new copy of Gridmapper, click on
*Prepare Download* and then click on *Download* – and you have an
upgraded, local copy of your dungeon!

Open it in your browser and check that everything works before
deleting your old copy. :)

Editing Maps using a Text Editor
--------------------------------

You can use the **Link URL** to make edits to your map.

Assume you have these two maps:
[One](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftfw.wfwwfww.dddfw%0A%20wfffwnnnn%20nn%20wfwwfwwfw%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww)
and
[Two](https://campaignwiki.org/gridmapper.svg?%0A%20ffnn%20n%20nn%20ffnn%0A%20dfbfdfwfwfbf%0A%20ffnnn%20fwfdffnnn).
The first thing to realize is that you can take those two maps and
turn them into strings. Replace ```%20``` with a space and ```%0A```
with a newline.

One:

```
 w.dfwwfwwfw
 wftfw.wfwwfww.dddfw
 wfffwnnnn nn wfwwfwwfw
 ww ww w.dfffwfn nnn w
   ww ww ww wfnnnn fd
      ww ww ww
```

Two:

```

 ffnn n nn ffnn
 dfbfdfwfwfbf
 ffnnn fwfdffnnn
```

First, we need to shift it over by 10 spaces:

```

           ffnn n nn ffnn
           dfbfdfwfwfbf
           ffnnn fwfdffnnn
```

Then we combine them, and we add a little extra: we can tell
Gridmapper to return to the top left corner by providing ```(0,0)```.
Here’s the combined map.

```

 w.dfwwfwwfw
 wftfw.wfwwfww.dddfw
 wfffwnnnn nn wfwwfwwfw
 ww ww w.dfffwfn nnn w
   ww ww ww wfnnnn fd
      ww ww ww
(0,0)
           ffnn n nn ffnn
           dfbfdfwfwfbf
           ffnnn fwfdffnnn
```

Turn spaces back into ```%20```, newlines into ```%0A```, and append it to
the Gridmapper URL: [Combined Map](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftfw.wfwwfww.dddfw%0A%20wfffwnnnn%20nn%20wfwwfwwfw%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww%0A(0,0)%0A%20%20%20%20%20%20%20%20%20%20%20ffnn%20n%20nn%20ffnn%0A%20%20%20%20%20%20%20%20%20%20%20dfbfdfwfwfbf%0A%20%20%20%20%20%20%20%20%20%20%20ffnnn%20fwfdffnnn)

You could now go back to your map and move the second map around in
relation to the first map by adding or removing newlines and spaces.
And when you’re good to go, click on *Prepare Link* and on the
resulting *Link*. You should get a "simplified" link that results in
the same map: [Simplified Combined Map](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%20%20%20%20%20%20%20ffnn%20n%20nn%20ffnn%0A%20wftfw.wfwwfww.dddfw%20%20%20%20dfbfdfwfwfbf%0A%20wfffwnnnn%20nn%20wfwwfwwfw%20%20ffnnn%20fwfdffnnn%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww)

Instead of putting the two maps on the same level, how about putting
one on the map below? Use ```z``` instead of ```(0,0)```:

```

 w.dfwwfwwfw
 wftfw.wfwwfww.dddfw
 wfffwnnnn nn wfwwfwwfw
 ww ww w.dfffwfn nnn w
   ww ww ww wfnnnn fd
      ww ww ww
z
           ffnn n nn ffnn
           dfbfdfwfwfbf
           ffnnn fwfdffnnn
```

Turn spaces back into ```%20```, newlines into ```%0A```, and this is what you’ll get:
[Stacked Combined Maps](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftfw.wfwwfww.dddfw%0A%20wfffwnnnn%20nn%20wfwwfwwfw%0A%20ww%20ww%20w.dfffwfn%20nnn%20w%0A%20%20%20ww%20ww%20ww%20wfnnnn%20fd%0A%20%20%20%20%20%20ww%20ww%20ww%0Az%0A%20%20%20%20%20%20%20%20%20%20%20ffnn%20n%20nn%20ffnn%0A%20%20%20%20%20%20%20%20%20%20%20dfbfdfwfwfbf%0A%20%20%20%20%20%20%20%20%20%20%20ffnnn%20fwfdffnnn)

See Also
--------

The project was the result of admiring Daniel R. Collins’ [original
GridMapper 1.0](http://www.superdan.net/software/gridmapper/).

This originally started as a Clojure project. You can find the Clojure
code on the
[clojure](https://github.com/kensanata/gridmapper/tree/clojure)
branch.

There is also a branch called
[c2](https://github.com/kensanata/gridmapper/tree/c2) which uses
[C2](https://keminglabs.com/c2/) to create a web application.
Unfortunately, it doesn’t scale well: when you use a 30×30 grid, it’s
too slow. I decided to move to [VanillaJS](http://vanilla-js.com/).

There’s also a very good looking, Flash based website with a similar
interface called [ANAmap](http://deepnight.net/anamap/).
