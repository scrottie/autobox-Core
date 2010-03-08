use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = "THIS IS A STRING";

is $string->lcfirst, 'tHIS IS A STRING';

