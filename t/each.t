use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my %hash = ( foo => 1, bar => 2, baz => 3 );

my @glued;
%hash->each( sub { push @glued, $_[0] . $_[1] } );

is_deeply [ sort @glued ], [ qw(bar2 baz3 foo1) ];

my @array = values %hash;

my @added;
@array->each( sub { push @added, $_[0] + 1 } );

is_deeply [ sort @added ], [ qw(2 3 4) ];

# Ensure each() always iterates through the whole hash
{
    my %want = (foo => 23, bar => 42, baz => 99, biff => 66);

    # Call each once on %want to start the iterator attached to %want
    my($k,$v) = each %want;

    my %have;
    %want->each( sub { $have{$_[0]} = $_[1] } );

    is_deeply \%have, \%want;
}
