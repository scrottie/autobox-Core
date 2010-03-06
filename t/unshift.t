use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar);

my @returned = @array->unshift('baz');

is_deeply \@array,    [qw(baz foo bar)];
is_deeply \@returned, [qw(baz foo bar)];

my $arrayref = @array->unshift('baz');

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";

my $array = [qw(foo bar)];

$array->unshift('baz');

is_deeply $array, [qw(baz foo bar)];

