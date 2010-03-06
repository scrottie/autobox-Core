use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

is 'A'->ord, ord('A');
