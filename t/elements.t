use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar baz);

my @returned = @array->elements;

is_deeply \@returned, \@array;

my $count = @array->elements;

is $count, 3;

