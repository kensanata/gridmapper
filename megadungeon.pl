use Modern::Perl;
use Mojolicious::Lite;
use Mojo::Log;
use Data::Dumper;
use Encode qw(encode_utf8);
use GD;
use MIME::Base64;
use List::Util qw(shuffle);

my $log = Mojo::Log->new;

my $maxx = 30;
my $maxy = 30;
my $maxz = 10;

get '/' => sub {
  my $c = shift;
  # my $seed = 0;
  # srand($seed);
  $log->debug("************************************************************");
  my $map = generate_map();
  $c->render(template => 'main',
             links => [@{$map->{links}}],
	     images => [@{$map->{images}}]);
};

sub generate_map {
  my $map = {}; # $map->{data}->[$z][$y][$x], $map->{queue}
  init($map);
  my $n = 1;
  do {} while (process($map, $n++));
  return $map;
}

sub init {
  my ($map) = @_;
  my $space = 5;
  my $x = int(rand($maxx + 1 - 2 * $space) + $space); # 5 - 25
  my $y = int(rand($maxy + 1 - 2 * $space) + $space); # 5 - 25
  push(@{$map->{queue}}, ['big room', $x, $y, 0]);
}

sub process {
  my ($map, $n) = @_;
  $log->debug('-' x 57 . sprintf(" %02d", $n));
  my $step = shift(@{$map->{queue}});
  if ($step->[0] eq 'room exit') {
    process_room_exit ($map, @$step[1 .. 4]);
  } elsif ($step->[0] eq 'corridor') {
    process_corridor ($map, @$step[1 .. 5]);
  } elsif ($step->[0] eq 'corridor end') {
    process_corridor_end($map, @$step[1 .. 4]);
  } elsif ($step->[0] eq 'small room') {
    process_small_room($map, @$step[1 .. 7]);
  } elsif ($step->[0] eq 'big room') {
    process_big_room($map, @$step[1 .. 7]);
  } elsif ($step->[0] eq 'spiral stairs') {
    process_spiral_stairs($map, @$step[1 .. 3]);
  } else {
    $log->error("Cannot process @$step");
  }
  push(@{$map->{links}}, to_link($map));
  push(@{$map->{images}}, to_image($map));
  return scalar(@{$map->{queue}});
}

sub pick_direction {
  return int(rand(4));
}

sub orthogonal {
  return (shift() + (rand() < 0.5 ? -1 : 1)) % 4;
}

sub back {
  return (shift() + 2) % 4;
}

sub left {
  return (shift() + -1) % 4;
}

sub right {
  return (shift() + +1) % 4;
}

sub one_in {
  my ($x1, $y1, $z1, $x2, $y2, $z2) = @_;
  my $x = $x1 + int(rand($x2 - $x1));
  my $y = $y1 + int(rand($y2 - $y1));
  my $z = $z1 + int(rand($z2 - $z1));
  return ($x, $y, $z);
}

sub d2 {
  return int(rand(2)) + 1;
}

sub about_three {
  return d2() + d2();
}

sub about_six {
  return 1 + d2() + d2() + d2();
}

sub suggest_door {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->debug("looking for door starting at ($x, $y, $z) in dir $dir");
  if ($map->{data}->[$z][$y][$x] eq 'd' x (1 + $dir) . 'f') {
    $log->debug("→ this door already exists ($x, $y, $z)");
    return -1;
  }
  my ($x1, $y1, $z1); # last legal position
  my $f;
  do {
    ($x1, $y1, $z1) = ($x, $y, $z);
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
  } while ($f and $f eq 'f');
  # return the last coordinates still on the floor
  if (not $f and legal($x1, $y1, $z1)) {
    $log->debug("→ found a position for a door at ($x1, $y1, $z1) in dir $dir");
    return ($x1, $y1, $z1);
  }
  $log->debug("→ cannot add door at ($x1, $y1, $z1)");
  return -1;
}

sub add_door {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->debug("checking for space at ($x,$y,$z) in dir $dir");
  my ($x1, $y1, $z1, $f) = step($map, $x, $y, $z, $dir);
  if (not legal($x1, $y1, $z1)) {
    $log->debug("→ but ($x1,$y1,$z1) is off the grid");
  } elsif ($map->{data}->[$z1][$y1][$x1]) {
    $log->debug("connecting to existing room at ($x,$y,$z)");
  } else {
    $log->debug("add door at ($x,$y,$z) in dir $dir");
    # doors are prefixed; multiple doors are separated by a dot
    if (substr($map->{data}->[$z][$y][$x], 0, 1) eq 'd') {
      $map->{data}->[$z][$y][$x] = '.' . $map->{data}->[$z][$y][$x];
    }
    $map->{data}->[$z][$y][$x] = 'd' x (1 + $dir) . $map->{data}->[$z][$y][$x];
  }
}

sub suggest_corridor {
  my ($map, $x, $y, $z, $dir, $d) = @_;
  my $f;
  $log->debug("looking for a corridor starting at ($x, $y, $z) in dir $dir, distance $d");
  # known position is the floor tile with the door, so first step is free
  ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
  for (1 .. $d) {
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
    if (not legal($x, $y, $z)) {
      $log->debug("→ found illegal position at ($x, $y, $z) in dir $dir, distance $_");
      return $_ - 1;
    } elsif ($f and $f eq 'f') {
      $log->debug("→ found floor $f at ($x, $y, $z) in dir $dir, distance $_");
      return $_;
    } else {
      my ($x1, $y1, $z1, $f) = step($map, $x, $y, $z, left($dir));
      if ($f and $f eq 'f') {
	$log->debug("→ found floor $f to the left at ($x, $y, $z) in dir $dir, distance $_");
	return $_;
      }
      ($x1, $y1, $z1, $f) = step($map, $x, $y, $z, right($dir));
      if ($f and $f eq 'f') {
	$log->debug("→ found floor $f to the right at ($x, $y, $z) in dir $dir, distance $_");
	return $_;
      }
    }
  }
  return $d;
}

sub add_corridor {
  my ($map, $x, $y, $z, $dir, $d) = @_;
  my $f;
  $log->debug("adding a corridor starting at ($x, $y, $z) in dir $dir, distance $d");
  for (1 .. $d) {
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
    if ($f) {
      $log->error("drawing tiles on existing floor at ($x,$y,$z)") if $f;
      last;
    }
    $map->{data}->[$z][$y][$x] = 'f';
    if ($_ == 3 and rand() < 0.3) {
      # add small corridor
      push(@{$map->{queue}}, ['corridor', $x, $y, $z, orthogonal($dir), about_three()]);
    }
  }
  my ($x1, $y1, $z1, $f1) = step($map, $x, $y, $z, $dir);
  if ($f1 and $f1 eq 'f') {
    $log->debug("adding a door at ($x, $y, $z) in dir $dir to ($x1, $y1, $z1) for '$f1'");
    $map->{data}->[$z][$y][$x] = 'd' x (1 + $dir) . $map->{data}->[$z][$y][$x];
  }
  return ($x, $y, $z);
}

sub process_corridor {
  my ($map, $x, $y, $z, $dir, $d) = @_;
  # add corridor
  $log->debug("processing corridor at ($x, $y, $z) in dir $dir, distance $d");
  $d = suggest_corridor($map, $x, $y, $z, $dir, $d);
  if ($d) {
    ($x, $y, $z) = add_corridor($map, $x, $y, $z, $dir, $d);
    push(@{$map->{queue}}, ['corridor end', $x, $y, $z, $dir]);
  }
}

sub process_corridor_end {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->debug("processing corridor end at ($x, $y, $z) in dir $dir");
  add_door($map, $x, $y, $z, $dir);
  # step into room
  my ($x1, $y1, $z1) = step($map, $x, $y, $z, $dir);
  if (rand() < 0.2) {
    push(@{$map->{queue}}, ['big room', $x1, $y1, $z1, $dir, $x, $y, $z]);
  } else {
    push(@{$map->{queue}}, ['small room', $x1, $y1, $z1, $dir, $x, $y, $z]);
  }
}

sub process_small_room {
  # ($x0, $y0, $z0) is the position we're coming from
  # ($x, $y, $z) is the first position inside the room
  my ($map, $x, $y, $z, $dir, $x0, $y0, $z0) = @_;
  $log->debug("processing small room at ($x, $y, $z) in dir $dir");
  # one corner: step straight ahead once or twice
  my ($x1, $y1, $z1) = step($map, $x, $y, $z, $dir);
  ($x1, $y1, $z1) = step($map, $x1, $y1, $z1, $dir) if rand() < 0.5;
  # other corner: step left or right
  my ($x2, $y2, $z2) = step($map, $x, $y, $z, orthogonal($dir));
  if (add_room($map, $x0, $y0, $z0,
	       min($x1, $x2), min($y1, $y2), min($z1, $z2),
	       max($x1, $x2), max($y1, $y2), max($z1, $z2))) {
    push(@{$map->{queue}}, ['room exit', one_in($x1, $y1, $z1, $x2, $y2, $z2), $dir]) if rand() < 0.7;
    push(@{$map->{queue}}, ['room exit', one_in($x1, $y1, $z1, $x2, $y2, $z2), $dir]) if rand() < 0.2;
    push(@{$map->{queue}}, ['spiral stairs', one_in($x1, $y1, $z1, $x2, $y2, $z2)]) if rand() < 0.2;
  } else {
    # t-crossing: add small corridors in both directions
    # push(@{$map->{queue}}, ['corridor', $x, $y, $z, left($dir), about_three()]);
    # push(@{$map->{queue}}, ['corridor', $x, $y, $z, right($dir), about_three()]);
  }
}

sub process_big_room {
  # the first big room has no direction and entry position
  my ($map, $x, $y, $z, $dir, $x0, $y0, $z0) = @_;
  my ($x1, $y1, $z1);
  my ($x2, $y2, $z2);
  if (defined $dir) {
    $log->debug("processing big room at ($x, $y, $z) in dir $dir");
    # one corner: step left once
    ($x1, $y1, $z1) = step($map, $x, $y, $z, left($dir));
    # other corner: step right once and straight two or three times
    ($x2, $y2, $z2) = step($map, $x, $y, $z, right($dir));
    ($x2, $y2, $z2) = step($map, $x2, $y2, $z2, $dir);
    ($x2, $y2, $z2) = step($map, $x2, $y2, $z2, $dir);
    ($x2, $y2, $z2) = step($map, $x2, $y2, $z2, $dir) if rand() < 0.5;
  } else {
    $log->debug("processing big room around ($x, $y, $z)");
    # on level 0, just have stairs going up to the surface
    $map->{data}->[$z][$y][$x] = 'svv '; # don't forget the space!
    ($x0, $y0, $z0) = ($x, $y, $z);
    ($x1, $y1, $z1) = ($x-1, $y-1, $z);
    ($x2, $y2, $z2) = ($x+1, $y+1, $z);
  }

  if (add_room($map, $x0, $y0, $z0,
	       min($x1, $x2), min($y1, $y2), min($z1, $z2),
	       max($x1, $x2), max($y1, $y2), max($z1, $z2))) {
    # the first room should always have at least one exit, usually more than one
    push(@{$map->{queue}}, ['room exit', one_in($x1, $y1, $z1, $x1, $y1, $z2)]) if not defined $dir;
    push(@{$map->{queue}}, ['room exit', one_in($x1, $y1, $z1, $x2, $y2, $z2), $dir]) if rand() < 0.7;
    push(@{$map->{queue}}, ['room exit', one_in($x1, $y1, $z1, $x2, $y2, $z2), $dir]) if rand() < 0.2;
    push(@{$map->{queue}}, ['spiral stairs', one_in($x1, $y1, $z1, $x2, $y2, $z2)]) if rand() < 0.2;
  } else {
    # t-crossing: add small corridors in both directions
    # push(@{$map->{queue}}, ['corridor', $x, $y, $z, left($dir), about_three()]);
    # push(@{$map->{queue}}, ['corridor', $x, $y, $z, right($dir), about_three()]);
  }
}

sub add_room {
  # ($x0, $y0, $z0) is the position we're coming from
  # ($x1, $y1, $z1) is one corner of the room
  # ($x2, $y2, $z2) is the other corner of the room
  my ($map, $x0, $y0, $z0, $x1, $y1, $z1, $x2, $y2, $z2) = @_;
  if (not legal($x1, $y1, $z1) or not legal($x2, $y2, $z2)) {
    $log->debug("→ the room goes over the edge of the map ($x1, $y1, $z1) to ($x2, $y2, $z2)");
    return 0;
  }
  my $f;
  for my $z ($z1 .. $z2) {
    for my $y ($y1 .. $y2) {
      for my $x ($x1 .. $x2) {
	# if we reached this room via stairs from above or below, then the
	# origin is inside the room and must not be checked
	if ($map->{data}->[$z][$y][$x] and not ($x == $x0 and $y == $y0)) {
	  $log->debug("→ the room already contains something at ($x, $y, $z): " . $map->{data}->[$z][$y][$x]);
	  return 0;
	}
	# if we reached this room from the same level, then the origin is
	# outside the room and touching it is not a problem
	if ($y == $y1 and $f = $map->{data}->[$z][$y-1][$x] and not ($x == $x0 and $y-1 == $y0)
	    or $y == $y2 and $f = $map->{data}->[$z][$y+1][$x] and not ($x == $x0 and $y+1 == $y0)
	    or $x == $x1 and $f = $map->{data}->[$z][$y][$x-1] and not ($x-1 == $x0 and $y == $y0)
	    or $x == $x2 and $f = $map->{data}->[$z][$y][$x+1] and not ($x+1 == $x0 and $y == $y0)) {
	  $log->debug("→ the room touches something at ($x, $y, $z): " . $f);
	  return 0;
	}
      }
    }
  }
  $log->debug("Adding room from ($x1, $y1, $z1) to ($x2, $y2, $z2)");
  for my $z ($z1 .. $z2) {
    for my $y ($y1 .. $y2) {
      for my $x ($x1 .. $x2) {
	$map->{data}->[$z][$y][$x] = 'f' unless $map->{data}->[$z][$y][$x]; # could be stairs
	$log->info("→ ($x, $y, $z): " . $map->{data}->[$z][$y][$x]);	
      }
    }
  }
  return 1;
}

sub process_spiral_stairs {
  my ($map, $x, $y, $z) = @_;
  my $dir = $z == 0 ? 1 : rand() < 0.5 ? 1 : -1;
  $log->debug("Trying to add stairs at ($x, $y, $z) going $dir");
  if ($map->{data}->[$z][$y][$x] eq 'f'
      and (not $map->{data}->[$z + $dir][$y][$x]
	   or $map->{data}->[$z + $dir][$y][$x] eq 'f')) {
    $log->debug("Add stairs at ($x, $y, $z) going $dir");
    $map->{data}->[$z][$y][$x] = 'svv ';
    $map->{data}->[$z + $dir][$y][$x] = 'svv ';
    push(@{$map->{queue}}, ['small room', $x, $y, $z + $dir, pick_direction(), $x, $y, $z]);
  } else {
    $log->debug("No room for more stairs");
  }
}

sub process_room_exit {
  my ($map, $x, $y, $z, $skip_dir) = @_;
  # add corridor
  $log->debug("processing room exit at ($x, $y, $z)"
	      . (defined $skip_dir ? " but not dir $skip_dir" : ""));
  for my $dir (shuffle 0 .. 3) {
    next if defined $skip_dir and $skip_dir == $dir;
    # don't change ($x, $y, $z) because we need retries!
    my ($x1, $y1, $z1) = suggest_door($map, $x, $y, $z, $dir);
    next unless $x1 >= 0;
    my $d = about_six();
    $d = suggest_corridor($map, $x1, $y1, $z1, $dir, $d);
    next unless $d;
    add_door($map, $x1, $y1, $z1, $dir);
    ($x1, $y1, $z1) = add_corridor($map, $x1, $y1, $z1, $dir, $d);
    push(@{$map->{queue}}, ['corridor end', $x1, $y1, $z1, $dir]);
    last;
  }
}

sub legal {
  my ($x, $y, $z) = @_;
  return ($x >= 0 and $x <= $maxx
	  and $y >= 0 and $y <= $maxy
	  and $z >= 0 and $z <= $maxz);
}

sub min {
  my ($m, $n) = @_;
  return $m > $n ? $n : $m;
}

sub max {
  my ($m, $n) = @_;
  return $m > $n ? $m : $n;
}

# 0 is to the left
sub step () {
  my ($map, $x, $y, $z, $dir) = @_;
  # $log->debug("→ stepping from ($x, $y, $z) in dir $dir");
  if ($dir == 0) {
    return ($x - 1, $y, $z, $map->{data}->[$z][$y][$x-1]);
  } elsif ($dir == 1) {
    return ($x, $y - 1, $z, $map->{data}->[$z][$y-1][$x]);
  } elsif ($dir == 2) {
    return ($x + 1, $y, $z, $map->{data}->[$z][$y][$x+1]);
  } elsif ($dir == 3) {
    return ($x, $y + 1, $z, $map->{data}->[$z][$y+1][$x]);
  } else {
    $log->error("step: invalid direction");
  }
}

sub to_link {
  my $map = shift;
  return 'https://campaignwiki.org/gridmapper.svg?'
      . url_encode(to_string($map))
      # append coordinates
      . '(0,0)0%201%202%203%204%205%206%207%208%209%2010%2011%2012%2013%2014%2015%2016%2017%2018%2019%2020%2021%2022%2023%2024%2025%2026%2027%2028%2029%20%0a1%0a2%0a3%0a4%0a5%0a6%0a7%0a8%0a9%0a10%0a11%0a12%0a13%0a14%0a15%0a16%0a17%0a18%0a19%0a20%0a21%0a22%0a23%0a24%0a25%0a26%0a27%0a28%0a29'
}

sub to_string () {
  my $map = shift;
  my $str = "";
  # $log->debug(Dumper($map));
  for my $z (0 .. scalar(@{$map->{data}}) - 1) {
    $str .= "(0,0,$z)";
    $str .= "X[$maxx,$maxy]" unless $z;
    if ($map->{data}->[$z]) {
      for my $y (0 .. scalar(@{$map->{data}->[$z]}) - 1) {
	# $str .= "  01234567890123456789\n" unless $y;
	# $str .= sprintf("%02d", $y);
	if ($map->{data}->[$z][$y]) {
	  for my $x (0 .. scalar(@{$map->{data}->[$z][$y]}) - 1) {
	    $str .= $map->{data}->[$z][$y][$x] || ' ';
	  }
	}
	$str .= "\n";
      }
    }
  }
  return $str;
}

sub url_encode {
  my $str = shift;
  return '' unless $str;
  my @letters = split(//, encode_utf8($str));
  my %safe = map {$_ => 1} ('a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', '_', '.', '!', '~', '*', "'", '(', ')', '#');
  foreach my $letter (@letters) {
    $letter = sprintf("%%%02x", ord($letter)) unless $safe{$letter};
  }
  return join('', @letters);
}

sub to_image {
  my $map = shift;
  my $maxz = $#{$map->{data}};
  my $img = new GD::Image($maxx + 1, ($maxy + 1) * (1 + $maxz) + $maxz);
  my $white = $img->colorAllocate(255,255,255);
  my $black = $img->colorAllocate(0,0,0);       
  my $red   = $img->colorAllocate(255,0,0);       
  $img->transparent($white);
  for my $z (0 .. $maxz) {
    for my $y (0 .. $maxy) {
      for my $x (0 .. $maxx) {
	if ($map->{data}->[$z][$y][$x]) {
	  if (substr($map->{data}->[$z][$y][$x], 0, 1) eq 'd') {
	    $img->setPixel($x, $y + ($maxy + 1) * $z, $red);
	  } else {
	    $img->setPixel($x, $y + ($maxy + 1) * $z, $black);
	  }
	}
      }
    }
  }  
  my $url = "data:image/png;base64,"
      . encode_base64($img->png);
  return $url;
}

app->start;
__DATA__

@@ main.html.ep
% layout 'default';
% title 'Gridmapper Megadungeon Generator';
<h1>Gridmapper Megadungeon Generator</h1>
<p>
This is a generator for maps that can be fed to
<a href="https://campaignwiki.org/gridmapper.svg">Gridmapper</a>.
Below, you can see how it grew.
Click on the thumbnails and switch to Gridmapper.
<p>
<% my $n = 0; for my $link (@$links) { my $img = shift(@$images); $n++; %>\
<span style="display:inline-block; vertical-align:top;">
<%= $n %><br/>
<a style="text-decoration:none;" href="<%= $link %>">
    <img style="border: 1px solid gray;" src="<%= $img %>">
</a>
</span>
<% } %>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head>
<title><%= title %></title>
%= stylesheet '/gridmapper.css'
%= stylesheet begin
body { padding: 1em; font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif }
% end
<meta name="viewport" content="width=device-width">
</head>
<body>
<%= content %>
<div class="footer">
<hr>
<p>
<a href="https://alexschroeder.ch/wiki/Contact">Alex Schroeder</a> &nbsp; <a href="https://github.com/kensanata/gridmapper">Source on GitHub</a> &nbsp;
</div>
<p>
</body>
</html>
