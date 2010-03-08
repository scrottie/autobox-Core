use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my %hash = ( foo => 1, bar => 2, baz => 3 );

is_deeply [ sort %hash->keys ], [ qw( bar baz foo ) ];

my $arrayref = %hash->keys;

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
