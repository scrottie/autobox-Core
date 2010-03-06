use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my @list = qw(h i t h e r e);

is @list->join(''), 'hithere';
is @list->join(' '), 'h i t h e r e';
