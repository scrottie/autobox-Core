use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar);

my @returned = @array->push('baz');

is_deeply \@array,    [qw(foo bar baz)];
is_deeply \@returned, [qw(foo bar baz)];

my $arrayref = @array->push('baz');

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
my $array = [qw(foo bar)];

$array->push('baz');

is_deeply $array, [qw(foo bar baz)];

