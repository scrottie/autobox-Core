use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = "THIS IS A STRING";

is $string->length, 16;

my @array = qw(foo bar baz);

is @array->length, 3;

