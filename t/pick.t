#!/usr/bin/env perl

use Test::More 'no_plan';
use strict;
use warnings;

use autobox::Core;

my $arrayref = [ 1, 6, 8, 3, 2, 9, 5, 7, 4, 0 ];

my @pick_1 = $arrayref->pick;
my @pick_2 = $arrayref->pick(2);
my @pick_3 = $arrayref->pick(3);

is scalar @pick_1, 1, "Returns 1 random element";
is scalar @pick_2, 2, "Returns 2 random elements";
is scalar @pick_3, 3, "Returns 3 random elements";
