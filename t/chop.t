use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = "This is a string";

my $char = $string->chop;

is $string, "This is a strin", "Chop modifies the string";
is $char, "g", "... and returns the last character";

TODO: {

    todo_skip "Chop should work on lists too", 2;

    my @list = qw(foo bar baz);

    my $char = @list->chop;

    is $char, 'z';

    is_deeply \@list, [ 'fo', 'ba', 'ba' ];
}

