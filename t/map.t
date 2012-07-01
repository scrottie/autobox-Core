use Test::More;
use strict;
use warnings;

use autobox::Core;


{
    my @array = qw(1 2 3);

    my @added = @array->map(sub { ++$_ });

    is_deeply \@added, [qw(2 3 4)];

    my $arrayref = @array->map( sub { 'foo' } );

    is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
}

done_testing;
