use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

is 'W'->unpack("foo"), unpack('W', "foo");
