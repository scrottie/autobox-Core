use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

my $string = "I like pie pie";
my $substr = "pie";

is $string->rindex($substr), rindex($string, $substr);
is $string->rindex($substr, 12), rindex($string, $substr, 12);

