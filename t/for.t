use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(1 2 3);

my @added;
@array->for( sub { my ($i, $v, $arr) = @_; push @added, $i + $v + @$arr } );

is_deeply [ @added ], [ qw(4 6 8) ];
