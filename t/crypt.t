use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

use Config;
SKIP: {
    skip("crypt not defined on this system", 1) unless $Config{d_crypt};
    is 'PLAINTEXT'->crypt('SALT'), 'SAPH9ylAEPe62';
}