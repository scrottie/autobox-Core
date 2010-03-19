#!/usr/bin/env perl
use Test::More;
use autobox::Core;

my %hash = ( 1 => 'foo', 2 => 'bar', 3 => 'bar' );
my $f;

is_deeply( $f = %hash->flip, { foo => 1, bar => 3 } );

my %f = %hash->flip;

is_deeply( \%f, { foo => 1, bar => 3 }, "Returns hash in list context" );

my %nested = ( 1 => { foo => 'bar' }, 2 => 'bar' );

done_testing;
