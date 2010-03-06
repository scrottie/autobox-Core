use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = 'HELLO';
$string->s('^HE', 'Hu');

is $string, 'HuLLO';
