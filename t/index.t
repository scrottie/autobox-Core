use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

my $string = "I like pie";
my $substr = "pie";

is $string->index($substr), 7;
is $string->index($substr, 8), -1;

