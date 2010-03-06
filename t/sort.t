use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(foo bar baz);

my @returned = @array->sort;

is_deeply \@returned, [qw(bar baz foo)];

@returned = @array->sort(sub { $_[1] cmp $_[0] });

is_deeply \@returned, [qw(foo baz bar)];

my $arrayref = @array->sort;

is ref $arrayref, "ARRAY", "Returns an arrayref in scalar context";
