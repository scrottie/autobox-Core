
use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $foo = '';

is $foo->vec(0, 32), vec($foo, 0, 32);  # 0x5065726C, 'Perl'
is $foo->vec(2, 16), vec($foo,  2, 16); # 0x5065, 'PerlPe'
is $foo->vec(3, 16), vec($foo,  3, 16); # 0x726C, 'PerlPerl'
