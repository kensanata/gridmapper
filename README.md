Gridmapper
==========

Open the [gridmapper.svg](https://campaignwiki.org/gridmapper.svg)
file using your browser and you have a very simple dungeon mapping
tool.

- quick keyboard navigation
- support for multiple levels
- collaboration with others

The user interface comes with a help screen explaining all the
details, and a link to a demo. The map icons are inspired by the icons
in Moldvay's *Basic D&D*. There's a screenshot in
[this review on RPG Geeks](http://rpggeek.com/thread/659631/game-got-it-started-me).
Here's
[a Master Dungeon Mapping Key PDF](http://savevsdragon.blogspot.ch/2012/03/free-download-master-dungeon-mapping.html),
if you want something more recent.

![Screenshot](https://raw.githubusercontent.com/kensanata/gridmapper/master/images/gridmapper.png)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Gridmapper](#gridmapper)
    - [It's Free](#its-free)
    - [Keyboard Focus](#keyboard-focus)
    - [Internet Explorer Issues](#internet-explorer-issues)
    - [Chrome Issues](#chrome-issues)
    - [Examples](#examples)
- [How to Collaborate](#how-to-collaborate)
- [How to Save](#how-to-save)
- [Scripting](#scripting)
- [How to extend Gridmapper](#how-to-extend-gridmapper)
- [Installation on your own Web Server](#installation-on-your-own-web-server)
- [See Also](#see-also)

<!-- markdown-toc end -->

It's Free
---------

Also note that Gridmapper is
totally [free and gratis](LICENSE.md#the-license). It costs nothing to
use, and you can do with it what you want. You can copy, modify,
distribute and perform the work, even for commercial purposes, all
without asking permission.

Keyboard Focus
--------------

Gridmapper was designed to be usable with the keyboard. And yet, the
mouse can be important to move around on a large map and to draw rough
outlines.

The help screen is supposed to help mouse users. You can click most
tiles and they'll get inserted at the current position. If you use the
mouse to position the pointer on the map, the pointer will follow the
mouse as you move to the right in order to pick a tile. Press the
Shift key to prevent the pointer from following the mouse.

Remember that sometimes you need to click the *letter* in order to
rotate an element.

Internet Explorer Issues
------------------------

Written using [Vanilla JS](http://vanilla-js.com/). Unfortunately,
Internet Explorer isn't well supported. That's because it mixes SVG
and XHTML in the same document and that appears not to work for IE.
I'm trying to simply remove the stuff that doesn't work.

Chrome Issues
-------------

When zooming in or out, the text area will not get moved along with
all the other elements. As far as I am concerned, this is a Chrome
bug.

Examples
--------

* [Gridmapper Logo](https://campaignwiki.org/gridmapper.svg?%0A%20f%20ss%20f%0A%20s%0A%20%20%20%20sss%0A%20fssss%20%20f)
* [OSR Logo](https://campaignwiki.org/gridmapper.svg?%0A%20w.dfwwfwwfw%0A%20wftv%20fw.wfwwfww.dddfw%0A%20wfffwnnnnv%20wwnnv%20wfwwfwwfw%0A%20ww%20ww%20w.dfwwffwfw.wnv%20nnnv%0A%20%20%20ww%20ww%20ww%20wfwnnnnv%20wwfd%0A%20%20%20%20%20%20ww%20%20wwj)
* [Demo Dungeon](https://campaignwiki.org/gridmapper.svg?%2813%2C11%29ffff%0A%20%20%20%20%20%20%20%20%20%20%20ssss%20%20ff1ffdffssssv%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffdfnn%0A%20%20%20%20%20%20%20%20%20%20%20%20%20ffffnnnn%20fff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20fddvvvf%20%20%204ffdvvfff%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20ff%20%20%20%20%20f5fdddvf%0A%20%20%20%20%20%20%20%20%20%20%20p%20p%20p%20ffdvf%20%20%20%20fff%0A%20%20%20%20%20%20%20%20%20%20%20b%20t%20f2ffwf%0A%20%20%20%20%20%20%20%20%20%20%20p%20p%20p%20ffwfz%2821%2C11%29fwfwf%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%206fddfddfddfdv%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20ddfw.dfw.df)

You will have noticed that those example URLs contain a lot of
gibberish past the questionmark. This is the URL's **query string**.
It's a sort of code that's very close to a stream of keyboard
commands. You can get this link by clicking on *Prepare Link* and then
clicking on the resulting *Link*. Perfect for sharing and bookmarking.

For more examples, check out
this [Google+ Collection](https://plus.google.com/collection/wvkofB).

How to Collaborate
==================

Gridmapper allows multiple people to draw on the same map. In order to
do this, you must all type the same map name into the text area and
click the **Join** link. You probably still need a way to talk or chat
online.

![Screenshot](https://raw.githubusercontent.com/kensanata/gridmapper/master/images/map-name.png)

Alternatively, one of you
opens [Gridmapper](https://campaignwiki.org/gridmapper.svg), provides
a name in the text area and clicks **Join**. The others connect to
the [Gridmapper Server](https://campaignwiki.org/gridmapper-server)
and click on the map, there.

If you want to keep it private, put a password on the second line.

How to Save
===========

This being a very simple web application, it has no access to your
file system. And worse: If you use "Save As..." in *Firefox* or *Chrome*
you'll save a copy *without* any of the changes you made!

These are your options:

- Click on **Save**. This will save your map on the wiki. This also
  makes it public because anybody can look at
  the
  [Gridmapper Campaign Wiki](https://campaignwiki.org/wiki/Gridmapper/HomePage).
  Thanks for sharing! It may also not be what you want if your players
  are watching the wiki. This does not work for *Internet Explorer*
  and it does not work if you are using a local copy of Gridmapper.
  Please provide some information in the text area: put the dungeon
  name on the first line, your name on the second line, and a
  description on the third line. Example:

```
Demo Dungeon
Alex Schroeder
First draft
```

- Click on **Download** and click on the resulting **TXT** link. This
  saves the current map as a text file. Use this if you don't want to
  save your map to the wiki. When you want to continue working on your
  map, use drag and drop to get the map into the text area and click
  **Import**. This does not work for *Internet Explorer*.

- Click on **Download** and click on the resulting **PNG** link. This
  downloads an image of the current level. This is what you would use
  if you wanted to continue working on your dungeon
  using [Gimp](https://gimp.org/) or Photoshop. Remember, if you want
  to *print* the dungeon, you need 300 dpi or 300 pixels per inch.
  You're probably better off using the SVG file and converting it to
  PDF. This does not work for *Internet Explorer*.

- Click on **Download** and click on the resulting **SVG** link. This
  is also what you would use if you wanted to continue working on your
  dungeon using an SVG editor such
  as [Inkscape](https://inkscape.org/). This will also allow you to
  save the map as a PDF file. This does not work for *Internet
  Explorer*.

- If you're using *Safari*, you can just save the page. This will
  create a [webarchive](https://en.wikipedia.org/wiki/Webarchive).

- Click on **Export** and copy the content of the text area into a
  text file. When you come back later, paste the text file into the
  text area and click **Import**. This text file is basically a little
  script recreating your dungeon. This does not work for *Internet
  Explorer*.

- Click on **Link** and bookmark the new page. The link now basically
  contains a little script recreating your dungeon. You might have to
  use a URL shortener such as [goo.gl](https://goo.gl/) when pasting
  the URL into a chat window or when sharing it on social media. As
  browsers and web sites have size limitations on the length of a
  link, this will not work for *big* dungeons. This is what you would
  use for quickly sharing a link.

Scripting
=========

It's possible to use the text area for some simple scripting. Paste
the following in the text area, for example, and use **Ctrl Enter** as
you move around on the map. It will surround your current square with
walls.

```
[-1,-1]fff[-3,1]f f[-3,1]fff[-2,-1]
```

Scripting works by typing the commands you would need to type, with
the following additions:

1. `f` will place a floor *and automatically advance* (like a
   right arrow)

2. `-` will move left by one (like a left arrow)

3. `.` is used to stop rotations; thus `ddd` will place a door
   and rotate it three times where as `d.dd` will place one door
   and a second door, and rotate it once

4. `;` is used to pause for half a second; it might be useful if
   you're writing a demo for somebody else

5. `(x,y)` or `(x,y,z)` will automatically move to the new position
   (be sure to add 0.5 to either x or y in Wall Mode); note that
   `(0,0)` is the top left corner and positive y is *down*

6. `[dx,dy]` will move the current position relative to the
   current position; given that positive y is *down*, `[0,1]` is
   the equivalent of moving one down

7. `X[dx,dy]` wipe the rectangle to the right and down (no negative
   coordinates).

How to extend Gridmapper
========================

Let's assume you want to add *wells* as variants of *statues* to
Gridmapper – and let's assume this had not yet been implemented. How
would you do it?

Step 1: Find the SVG definition of a statue and add the SVG you want
right next to it. Where to learn about SVG? Personally, I usually just
look at these sources:

1. [The SVG Specification](http://www.w3.org/TR/SVG/#minitoc)
2. [The SVG tutorials by Jakob Jenkov](http://tutorials.jenkov.com/svg/index.html)
3. [The SVG section on the Mozilla Developer Network](https://developer.mozilla.org/de/docs/Web/SVG)

The outermost element needs to have an *id* attribute that you will be
referring to later. It also needs a *width* attribute. This is used to
scale your element.

Thus, here's a little SVG element containing the white floor rectangle
and two circles. The outermost element has both an *id* and a *width*
attribute.

```
<g id="well" width="100">
  <rect width="100" height="100" fill="white" stroke="black" stroke-width="10"/>
  <circle cx="50" cy="50" r="25" fill="black"/>
  <circle cx="50" cy="50" r="15" fill="black" stroke="white" stroke-width="10"/>
</g>
```

Step 2: Register the variants. What we need to do is tell Gridmapper
that hitting `v` on a statue will turn it into a well and hitting
`v` on a well will turn it into a statue. Find the variants in the
source code and add the following:

```
variants: {
  ...,
  'statue': 'well',
  'well': 'statue',
},
```

Step 3: Document it. Find the section at the end where all the tiles
are documented. Search for `#statue`. Then, append something like
the following:

```
<a xlink:href="javascript:interpret('bv')" title="well">
  <use x="40" y="1" xlink:href="#empty"/>
  <use x="40" y="1" xlink:href="#well"/>
</a>
```

Save it, test it, you're done!

Installation on your own Web Server
===================================

Since the *query string* is of utmost importance, the limitations on
request length probably needs to raised. By default,
[Apache 2](http://httpd.apache.org/docs/2.2/mod/core.html#limitrequestfieldsize)
has a limit of 8190 for these two options. I've increased them as
follows in my web server config file:

```
LimitRequestLine      32000
LimitRequestFieldSize 32000
```

If you want hosting to work, you'll need to install
`gridmapper-server.pl` as a Mojolicious app using
[Hypnotoad](http://mojolicious.org/perldoc/Mojo/Server/Hypnotoad).
You cannot use Toadfarm, because it's important that the server use
only one instance. All the hosts and clients are in-memory. Nothing is
saved to the disk. Remember to change the hostname and port at the top
of the file.

If you're using Apache 2.2.22 (Debian Wheezy) as a proxy, you're in
trouble. The gridmapper-server itself is using HTTP on port 8082 and
the /join and /draw URLs are using WebSocket. This requires
**mod_proxy_wstunnel**. This required recompiling a patched Apache and
copying both mod_proxy and mod_proxy_wstunnel. You can find some links
[on my blog
post](https://alexschroeder.ch/wiki/2016-03-06_Gridmapper_using_Web_Sockets).

Apache config:

```
ProxyPass /gridmapper-server/join ws://campaignwiki.org:8082/join
ProxyPass /gridmapper-server/draw ws://campaignwiki.org:8082/draw
ProxyPass /gridmapper-server  http://campaignwiki.org:8082/
```

Starting Hypnotoad:

```
hypnotoad gridmapper-server.pl
```

See Also
========

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
