use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

is "  \t  \n  \t  foo  \t  \n  \t  "->strip, 'foo';
