use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar);

my @returned = @array->shift;

is_deeply \@array, [qw(bar)];
is_deeply \@returned, [qw(bar)];

my $arrayref = @array->shift;

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
