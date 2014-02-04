use Test::More;
use strict;
use warnings;

use autobox::Core;

{
    my @array = (1..12);
    my @res = ();

    @array->n_at_a_time(5, sub { push @res, scalar @_ });

    is_deeply
        [ @res    ],
        [ 5, 5, 2 ],
        'array case worked',
        ;
}
{
    my $aref = [ 1..12 ];
    my @res = ();
    $aref->n_at_a_time(5, sub { push @res, scalar @_ });

    is_deeply
        [ @res    ],
        [ 5, 5, 2 ],
        'arrayref case worked',
        ;
}

done_testing;
