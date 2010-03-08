#!/usr/bin/env perl

use Test::More 'no_plan';
use strict;
use warnings;

use autobox::Core;

my @array = qw(1 2 3);

my @odd = @array->grep(sub { $_ % 2 });

is_deeply \@odd, [qw(1 3)], "Expected coderef grep results";

my $arrayref = @array->grep( sub { 'foo' } );

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";

@array = qw( foo bar baz );
my $d;

ok ( eval { @array->grep( sub { 42 }  || 1) },  "Should accept code refs" );
ok ( eval { @array->grep( qr/foo/ ) || 1 }, "Should accept Regexps" );

is_deeply( $d = @array->grep('foo'),         [qw( foo )],     "Works with SCALAR"     );
is_deeply( $d = @array->grep('zar'),         [],              "Works with SCALAR"     );
is_deeply( $d = @array->grep(qr/^ba/),       [qw( bar baz )], "Works with Regexp"     );
is_deeply( $d = @array->grep(sub { /^ba/ }), [qw( bar baz )], "... as with Code refs" );

# context
my @d = @array->grep(qr/^ba/);

is scalar @d, 2, "Returns an array in list context";
SKIP: {
    skip "Only for 5.10", 1, if $] < 5.010;

    my @names = qw(barney booey moe);

    is_deeply( [ @names->grep(qr/^b/) ], [ qw(barney booey) ] );
    is_deeply( $d = @array->grep(+{ boo => 'boy' }), [],          "Works with HASH"       );
    is_deeply( $d = @array->grep([qw(boo boy)]), [],              "Works with ARRAY"      );
    is_deeply( $d = @array->grep([qw(foo baz)]), [qw(foo baz)],   "Works with ARRAY"      );
}

