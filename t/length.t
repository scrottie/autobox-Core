use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = "THIS IS A STRING";

is $string->length, 16;

my @array = qw(foo bar baz);

is @array->length, 3;

my $arrayref;

is $arrayref->length => undef, 'undef->length() returns undef';
$arrayref = [];
is $arrayref->length => 0,     '[]->length() returns 0';
