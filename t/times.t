use Test::More tests => 4;
use strict;
use warnings;

use autobox::Core;

is_deeply
    [ 3->times ],
    [ 0 .. 2 ],
    'no coderef, list context';

is_deeply
    do { my $ref = 3->times; $ref },
    [ 0 .. 2 ],
    'no coderef, scalar context';

my @sink;
2->times( sub { push @sink, $_ } );
is_deeply
    \@sink,
    [ 0 .. 1 ],
    'with coderef';

2->times( sub { push @sink, $_ + 1 } )
 ->times( sub { push @sink, $_ * 2} );
is_deeply
    \@sink,
    [ 0, 1, 1, 2, 0, 2 ],
    'with coderef and chaining';
