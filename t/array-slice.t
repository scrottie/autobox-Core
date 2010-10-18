#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 5;
use autobox::Core;

my @array = qw(foo bar baz);

ok @array->slice(0);
is_deeply [@array->slice(0)], ['foo'];
is_deeply [@array->slice(0,2)], ['foo', 'baz'];

my @slice = @array->slice(0,1);

is scalar @slice, 2, "Returns an array in list context";

my $slice = @array->slice(0,1);

is ref $slice, 'ARRAY', "Returns an arrayref in scalar context";
