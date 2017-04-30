use Modern::Perl;
use Mojolicious::Lite;
use Mojo::Log;
use Data::Dumper;

my $log = Mojo::Log->new;

my $maxx = 20;
my $maxy = 20;
my $maxz = 20;

get '/' => sub {
  my $c = shift;
  # my $seed = 0;
  # srand($seed);
  $log->debug("************************************************************");
  $c->render(template => 'main',
	     map => generate_map());
};

sub generate_map {
  my $map = {}; # $map->{data}->[$z][$y][$x], $map->{queue}
  push(@{$map->{queue}}, starting_room($map, 0, 5));
  do {} while (process($map));
  return to_string($map);
}

sub starting_room {
  my ($map, $z, $space) = @_;
  my $x1 = int(rand($maxx + 1 - 2 * $space) + $space); # 5 - 15
  my $y1 = int(rand($maxy + 1 - 2 * $space) + $space); # 5 - 15
  for my $x ($x1 - 1 .. $x1 + 1) {
    for my $y ($y1 - 1 .. $y1 + 1) {
      $map->{data}->[$z][$y][$x] = 'f';
    }
  }
  return ['large room', $x1, $y1, $z];
}

sub process {
  my $map = shift;
  my $step = shift(@{$map->{queue}});
  if ($step->[0] eq 'large room') {
    # add corridor
    my $x = $step->[1];
    my $y = $step->[2];
    my $z = $step->[3];
    $log->debug("processing large room at ($x, $y, $z)");
    for (0 .. 3) {
      my $dir = pick_direction();
      ($x, $y, $z) = suggest_door($map, $x, $y, $z, $dir);
      next unless $x >= 0;
      my $d = 6;
      $d = suggest_corridor($map, $x, $y, $z, $dir, $d);
      next unless $d;
      add_door($map, $x, $y, $z, $dir);
      ($x, $y, $z) = add_corridor($map, $x, $y, $z, $dir, $d);
      push(@{$map->{queue}}, ['corridor end', $x, $y, $z, $dir]);
      last;
    }
  } elsif ($step->[0] eq 'corridor') {
    # add corridor
    my $x = $step->[1];
    my $y = $step->[2];
    my $z = $step->[3];
    my $dir = $step->[4];
    my $d = $step->[5];
    $log->debug("processing corridor at ($x, $y, $z) in dir $dir, distance $d");
    $d = suggest_corridor($map, $x, $y, $z, $dir, $d);
    if ($d) {
      ($x, $y, $z) = add_corridor($map, $x, $y, $z, $dir, $d);
      push(@{$map->{queue}}, ['corridor end', $x, $y, $z, $dir]);
    }
  } elsif ($step->[0] eq 'corridor end') {
    my $x = $step->[1];
    my $y = $step->[2];
    my $z = $step->[3];
    my $dir = $step->[4];
    $log->debug("processing corridor end at ($x, $y, $z) in dir $dir");
    add_door($map, $x, $y, $z, $dir);
    push(@{$map->{queue}}, ['small room', $x, $y, $z, $dir]);
  } else {
    $log->error("Cannot process @$step");
  }
  return scalar(@{$map->{queue}});
}

sub pick_direction {
  return int(rand(4));
}

sub orthogonal {
  return (shift() + (rand() < 0.5 ? -1 : 1)) % 4;
}

sub suggest_door {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->debug("looking for door starting at ($x, $y, $z) in dir $dir");
  my ($x1, $y1, $z1);
  my $f;
  do {
    ($x1, $y1, $z1) = ($x, $y, $z);
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
  } while (defined($f));
  # return the last coordinates still on the floor
  if (legal($x1, $y1, $z1)) {
    $log->debug("→ staying at ($x1, $y1, $z1)");
    return ($x1, $y1, $z1);
  }
  $log->debug("→ illegal position ($x1, $y1, $z1)");
  return -1;
}

sub add_door {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->error("drawing door to empty floor at ($x,$y,$z)")
      unless $map->{data}->[$z][$y][$x];
  # doors are prefixed
  $map->{data}->[$z][$y][$x] = 'd' x (1 + $dir) . $map->{data}->[$z][$y][$x];
}

sub suggest_corridor {
  my ($map, $x, $y, $z, $dir, $d) = @_;
  my $f;
  $log->debug("looking for a corridor starting at ($x, $y, $z) in dir $dir, distance $d");
  # known position is the floor tile with the door, so first step is free
  ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
  for (1 .. $d) {
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
    return 0 if defined($f) or not legal($x, $y, $z);
  }
  return $d;
}

sub add_corridor {
  my ($map, $x, $y, $z, $dir, $d) = @_;
  my $f;
  $log->debug("adding a corridor starting at ($x, $y, $z) in dir $dir, distance $d");
  for (1 .. $d) {
    ($x, $y, $z, $f) = step($map, $x, $y, $z, $dir);
    $log->error("drawing tiles on existing floor at ($x,$y,$z)") if $f;
    $map->{data}->[$z][$y][$x] = 'f';
    if ($_ == 3 and rand() < 0.3) {
      # add small corridor
      push(@{$map->{queue}}, ['corridor', $x, $y, $z, orthogonal($dir), 3]);
    }
  }
  return ($x, $y, $z);
}

sub legal {
  my ($x, $y, $z) = @_;
  return ($x >= 0 and $x <= $maxx
	  and $y >= 0 and $y <= $maxy
	  and $z >= 0 and $z <= $maxz);
}

# 0 is to the left
sub step () {
  my ($map, $x, $y, $z, $dir) = @_;
  $log->debug("stepping from ($x, $y, $z) in dir $dir");
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

app->start;
__DATA__

@@ main.html.ep
% layout 'default';
% title 'Gridmapper Megadungeon Generator';
<h1>Gridmapper Megadungeon Generator</h1>
<p>
This is a generator for maps that can be fed to
<a href="https://campaignwiki.org/gridmapper.svg">Gridmapper</a>.
<p>
<textarea style="width: 25em; height: 25em;">
<%= $map %>
</textarea>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head>
<title><%= title %></title>
%= stylesheet '/gridmapper.css'
%= stylesheet begin
body { padding: 1em; font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif }
p { width: 80ex }
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
</body>
</html>
