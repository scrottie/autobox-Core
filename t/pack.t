use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

is 'nN'->pack(42, 4711), pack('nN', 42, 4711);
is '(sl)<'->pack(-42, 4711), pack('(sl)<', -42, 4711);
