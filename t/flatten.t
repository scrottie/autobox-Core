use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar baz);

my @returned = @array->flatten;

is_deeply \@returned, \@array;

my $count = @array->flatten;

is $count, 3;
