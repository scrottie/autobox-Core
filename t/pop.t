use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar);

my @returned = @array->pop;

is_deeply \@array, [qw(foo)];
is_deeply \@returned, [qw(foo)];

my $arrayref = @array->pop;

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
