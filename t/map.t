use Test::More qw(no_plan);
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

{
    my @array = qw(1 2 3);

    my $add = sub { ++$_ };

    my @added = $add->map(@array);

    is_deeply \@added, [qw(2 3 4)];

    my $arrayref = $add->map(@added);

    is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";
}

