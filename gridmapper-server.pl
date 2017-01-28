use Mojolicious::Lite;

app->config(hypnotoad => {
  listen => ['http://campaignwiki.org:8082'],
  workers => 1});

# API:
# /join/The_Map -- listen to "The_Map"
# -> your controller is stored in @{$clients{"The_Map"}}, making you a client
# -> the message "resend" will resend the entire map from the first client
# -> simply listening gets you the map as it is being drawn
# -> writing to the map will broadcast your message to all but you

my %clients;
my %resets;

get '/' => sub {
  my $c = shift;
  $c->render(template => 'main',
	     maps => [keys %clients]);
};

websocket '/join/:map' => sub {
  my $c = shift;
  my $map = $c->stash('map');

  # determine a number for the client
  my $num = 1;
 NUM:
  while (1) {
    for my $other (@{$clients{$map}}) {
      if ($num == $other->stash('id')) {
	$num++;
	next NUM;
      }
    }
    last;
  }
  $c->stash(id => $num);
  push(@{$clients{$map}}, $c);
  $c->app->log->debug("Client $num joined $map");

  # Increase inactivity timeout (seconds)
  $c->inactivity_timeout(300);

  # Incoming message
  $c->on(message => sub {
    my ($c, $msg) = @_;
    my $id = $c->stash('id');
    if ($msg eq "\cE") {
      # Ctrl-E is the Enquiry character. With it, a client requested a reset;
      # pass it on to the first client.
      if (@{$clients{$map}} > 1) {
	if ($clients{$map}->[0] eq $c) {
	  $clients{$map}->[1]->send("$msg");
	  my $other = $clients{$map}->[1]->stash('id');
	  $c->app->log->debug("$id is requesting a reset of $map, passing it to $other");
	} else {
	  $clients{$map}->[0]->send("$msg");
	  my $other = $clients{$map}->[0]->stash('id');
	  $c->app->log->debug("$id is requesting a reset of $map, passing it to $other");
	}
	$resets{$c} = 1;
      } else {
	$c->app->log->debug("$id is requesting a reset of $map but there are no other clients");
      }
    } elsif (substr($msg, 0, 1) eq "\cB") {
      # If it starts with Ctrl-B, then it's a reset message that's only sent to
      # the client(s) that requested it.
      for my $listener (@{$clients{$map}}) {
	if ($resets{$listener}) {
	  # Resets are only sent to those that requested one
	  delete($resets{$listener});
	  $listener->send("$msg");
	  my $other = $listener->stash('id');
	  $c->app->log->debug("$id is sending a reset of $map to $other");
	}
      }
      $c->app->log->debug("$id finished broadcasting the reset of $map");
      $c->app->log->debug("$map:\n" . substr($msg, 1));
    } else {
      # Everything else is broadcast to all the clients except to the one who
      # sent it. Use Ctrl-A to introduce the message, send the client number (so
      # that others can keep separate positions), then Ctrl-B to announce the
      # end of the number and the beginning of the text, then the message
      # itself, and Ctrl-C to indicate the end of the message for the
      # interpreter.
      for my $listener (@{$clients{$map}}) {
	if ($listener != $c) {
	  my $other = $listener->stash('id');
	  $listener->send("\cA$id\cB$msg\cC");
	  $c->app->log->debug("$id is sending $msg to $other");
	}
      }
      # $c->app->log->debug("$id finished broadcasting of $msg");
    }
  });

  # Closed
  $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    if (@{$clients{$map}}) {
      my @listeners = @{$clients{$map}};
      my $index = 0;
      $index++ until $listeners[$index] == $c or $index > @listeners;
      splice(@listeners, $index, 1);
      $clients{$map} = \@listeners;
      $c->app->log->debug("Left $map");
    }
    if (not @{$clients{$map}}) {
      delete($clients{$map});
      $c->app->log->debug("Freeing $map");
    }
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
<% if (@$maps) { %>\
<p>
Currently hosting the following maps:
<ul>
<% for my $map (@$maps) { %>\
<li><%= link_to "https://campaignwiki.org/gridmapper.svg?join=$map" => begin %><%= $map %><% end %>
<% } %>\
</ul>
<% } else { %>\
<p>
Currently no maps are being hosted.
<% } %>\

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
