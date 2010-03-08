use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;


my $times = sub { $_[0] * $_[1] };

my $times_two = $times->curry(2);
my $times_four = $times->curry(4);

is $times_two->(5), 10;
is $times_four->(5), 20;
