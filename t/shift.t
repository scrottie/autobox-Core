use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar);

is @array->shift, 'foo';

is_deeply \@array, [qw(bar)];
