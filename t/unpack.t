use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

SKIP: {
    skip "Only for 5.10", 1, if $] < 5.010;
    is 'W'->unpack("foo"), unpack('W', "foo");
};
