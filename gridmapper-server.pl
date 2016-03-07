use Mojolicious::Lite;

app->config(hypnotoad => {listen => ['http://campaignwiki.org:8082'], workers => 1});

# API:
# /join/The_Map -- listen to "The_Map"
# -> the message "resend" will resend the entire map
# -> simply listening gets you the map as it is being drawn
# /draw/The_Map -- write to "The_Map"
# -> every message will get broadcast to anybody listening

my %clients;
my %hosts;
my %resets;

get '/' => sub {
  my $c = shift;
  $c->render(template => 'main',
	     maps => [keys %hosts]);
};

websocket '/join/:map' => sub {
  my $c = shift;
  my $map = $c->stash('map');
  if (not exists $clients{$map}) {
    $c->reply->exception("Nobody is hosting $map");
    return;
  }
  push(@{$clients{$map}}, $c);
  $c->app->log->debug('Joined ' . $map);

  # Increase inactivity timeout (seconds)
  $c->inactivity_timeout(300);
  
  # Incoming message
  $c->on(message => sub {
    my ($c, $msg) = @_;
    if ($msg eq 'reset' && $hosts{$map}) {
      $hosts{$map}->send("$msg");
      $resets{$c} = 1;
      $c->app->log->debug("Listener for $map requesting $msg");
    } else {
      $c->app->log->debug("Listener for $map ignoring message: $msg");
    }
  });

  # Closed
  $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    if ($clients{$map}) {
      my @listeners = @{$clients{$map}};
      my $index = 0;
      $index++ until $listeners[$index] == $c or $index > @listeners;
      splice(@listeners, $index, 1);
      $clients{$map} = \@listeners;
      $c->app->log->debug("Left $map");
    }
  });
};
  
websocket '/draw/:map' => sub {
  my $c = shift;
  my $map = $c->stash('map');
  if (exists $clients{$map}) {
    $c->reply->exception("$map is already in use");
  } else {
    $hosts{$map} = $c;
    $clients{$map} = ();
  }

  $c->app->log->debug('Hosting ' . $map);
  
  # Increase inactivity timeout (seconds)
  $c->inactivity_timeout(300);
  
  # Incoming message: If it starts with Ctrl-B, then it's a reset message that's
  # only sent to the client(s) that requested it.
  $c->on(message => sub {
    my ($c, $msg) = @_;
    if (substr($msg, 0, 1) eq "\cB") {
      for my $listener (@{$clients{$map}}) {
	if ($resets{$listener}) {
	  # Resets are only sent to those that requested one
	  delete($resets{$listener});
	  $listener->send("$msg");
	}
      }
    } else {
      for my $listener (@{$clients{$map}}) {
	$listener->send("$msg");
      }
    }
    $c->app->log->debug("Drawing on $map: $msg");
  });

  # Closed
  $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    delete($clients{$map});
    delete($hosts{$map});
    $c->app->log->debug("Freeing $map");
  });
};

app->start;
__DATA__

@@ main.html.ep
% layout 'default';
% title 'Gridmapper Server';
<h1>Gridmapper Server</h1>
<p>
This is the Gridmapper Server.
The <a href="https://campaignwiki.org/gridmapper.svg">Gridmapper</a>
web application connects to it in order to share maps.
<p>
Currently sharing the following maps:
<ul>
<% for my $map (@$maps) { %>\
<li><%= $map %>
<% } %>\
</ul>

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
