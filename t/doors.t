use Modern::Perl;
use Test::More;
use FindBin;
require "$FindBin::Bin/../megadungeon.pl";

my $map = {};

#   0 1 2
# 0 _ _ _
# 1 _ _ f
# 2 _ _ _

#   1
# 0 x 2
#   3

$map->{data}->[0][1][2] = 'f';

add_door($map, 2, 1, 0, 0);

like($map->{data}->[0][1][2], qr/^[dw]v*f$/, 'added west door: ' . $map->{data}->[0][1][2]);

add_door($map, 2, 1, 0, 1);

like($map->{data}->[0][1][2], qr/^[dw]v*\.[dw]v*f$/, 'added north door: ' . $map->{data}->[0][1][2]);

# reset

$map->{data}->[0][1][2] = 'f';

add_door($map, 2, 1, 0, 1);

like($map->{data}->[0][1][2], qr/^(dd|ww)v*f$/, 'added north door after reset: ' . $map->{data}->[0][1][2]);

add_door($map, 2, 1, 0, 0);

like($map->{data}->[0][1][2], qr/^[dw]v*\.[dw]v*f$/, 'added west door: ' . $map->{data}->[0][1][2]);

done_testing();
