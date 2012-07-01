use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $num = 0.5;
my $e   = 1E-10;

cmp_ok( abs($num->abs  - abs($num)),  '<', $e );
cmp_ok( abs($num->cos  - cos($num)),  '<', $e );
cmp_ok( abs($num->exp  - exp($num)),  '<', $e );
cmp_ok( abs($num->int  - int($num)),  '<', $e );
cmp_ok( abs($num->log  - log($num)),  '<', $e );
cmp_ok( abs($num->oct  - oct($num)),  '<', $e );
cmp_ok( abs(05->hex    - hex(05)),    '<', $e );
cmp_ok( abs($num->sin  - sin($num)),  '<', $e );
cmp_ok( abs($num->sqrt - sqrt($num)), '<', $e );

cmp_ok( abs($num->atan2($num) - atan2($num, $num)), '<', $e );
