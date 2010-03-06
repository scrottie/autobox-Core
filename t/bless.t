use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my %struct = (
    ARRAY  => [ 'foo' ],
    HASH   => { 'foo' => 1 },
    CODE   => sub { 'foo' },
);

foreach my $reftype ( keys %struct ) {
    $struct{$reftype}->bless("Object");
    is ref $struct{$reftype}, "Object";
}

TODO: {
    todo_skip "Make it work for Regexp, Scalar and Glob", 3;
    my %todo = (
        Regexp => qr/foo/,
        SCALAR => \'foo',
        GLOB   => \*STDIN,
    );

    foreach my $reftype ( keys %todo ) {
        $todo{$reftype}->bless("Object");
        is ref $todo{$reftype}, "Object";
    }
}

