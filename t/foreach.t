use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(1 2 3);

my @added;
@array->foreach( sub { push @added, $_[0] + 1 } );

is_deeply [ sort @added ], [ qw(2 3 4) ];
