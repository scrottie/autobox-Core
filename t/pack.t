use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

SKIP: {
    # XXX this and pack.t could use a counterpart that works on 5.8 but this is so utterly non-urgent -- sdw
    skip "Only for 5.10", 1, if $] < 5.010;
    is 'nN'->pack(42, 4711), pack('nN', 42, 4711);
    is '(sl)<'->pack(-42, 4711), pack('(sl)<', -42, 4711);
};

ok(1);
