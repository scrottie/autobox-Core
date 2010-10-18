#!/usr/bin/env perl

use autobox::Core;
use Test::More tests => 3;

my @numbers = ( 1 .. 10 );

is( @numbers->last_index, 9 );
is( @numbers->last_index( sub { $_[0] > 2 } ), 9 );

is( @numbers->last_index( qr/^1/ ), 9 );
