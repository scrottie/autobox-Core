#!/usr/bin/env perl

use autobox::Core;
use Test::More 'no_plan';

my @array = qw( foo bar baz );
my $d;

ok ( eval { @array->grep( sub { 42 }  || 1) },  "Should accept code refs" );
ok ( eval { @array->grep( qr/foo/ ) || 1 }, "Should accept Regexps" );

is_deeply( $d = @array->grep('foo'),         [qw( foo )],     "Works with SCALAR"     );
is_deeply( $d = @array->grep('zar'),         [],              "Works with SCALAR"     );
is_deeply( $d = @array->grep(qr/^ba/),       [qw( bar baz )], "Works with Regexp"     );
if( $] >= 5.010 ) {
    is_deeply( $d = @array->grep(+{ boo => 'boy' }), [],          "Works with HASH"       );
    is_deeply( $d = @array->grep([qw(boo boy)]), [],              "Works with ARRAY"      );
    is_deeply( $d = @array->grep([qw(foo baz)]), [qw(foo baz)],   "Works with ARRAY"      );
}
is_deeply( $d = @array->grep(sub { /^ba/ }), [qw( bar baz )], "... as with Code refs" );

# context
my @d = @array->grep(qr/^ba/);

is scalar @d, 2, "Returns an array in list context";

