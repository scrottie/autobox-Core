#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;
use autobox::Core;

my @array = qw(foo bar baz);
my @array_cp = @array;

my @uniq = @array_cp->uniq;

is_deeply \@array_cp, \@uniq;

@array_cp = (@array, @array);
@uniq = @array_cp->uniq;

is_deeply \@uniq, \@array;  # this assumes that the duplicate filtering is stable (doesn't re-sort the values), which isn't a promise it makes

is_deeply [ [undef, 1, 2, 1, 2, ]->uniq ], [ undef, 1, 2];
