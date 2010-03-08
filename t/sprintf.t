use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $format = "%.2f"; 

is $format->sprintf(2/3), "0.67";
