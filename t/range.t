#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use autobox::Core;

my @array = qw(foo bar baz gorch);

ok @array->range(0,1);
is_deeply [@array->range(0,1)], ['foo', 'bar'];

my @slice = @array->range(0,2);

is scalar @slice, 3, "Returns an array in list context";

my $slice = @array->range(0,2);

is ref $slice, 'ARRAY', "Returns an arrayref in scalar context";

done_testing();
