use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $string = 'HELLO';
$string->s('^HE', 'Hu');

is $string, 'HuLLO';

ok $string->s(qr/LO/, '10') eq 'HuL10';     # using ok() instead of is() to test Want picking up on scalar context

ok ! $string->s(qr/LO/, '10');              # testing Want picking up on boolean context
ok ! ! $string->s(qr/10/, 'lo');              # testing Want picking up on boolean context

