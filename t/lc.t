use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = "THIS IS A STRING";

is $string->lc, "this is a string";
