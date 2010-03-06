use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @array = qw(1 2 3);

my @odd = @array->grep(sub { $_ % 2 });

is_deeply \@odd, [qw(1 3)];

my $arrayref = @array->grep( sub { 'foo' } );

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";

SKIP: {
    skip "Only for 5.10", 1, if $] < 5.010;

    my @names = qw(barney booey moe);

    is_deeply( [ @names->grep(qr/^b/) ], [ qw(barney booey) ] );
}

