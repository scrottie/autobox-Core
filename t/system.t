use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

is $^X->system(qw(-e1)), 0;
