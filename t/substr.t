use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

my $s = "The black cat climbed the green tree";
my $color  = $s->substr(4, 5);

is $color, 'black';

my $middle = $s->substr(4, -11);

is $middle, 'black cat climbed the';

my $end = $s->substr(14);
is $end, 'climbed the green tree';

my $tail = $s->substr(-4);
is $tail, 'tree';

my $z = $s->substr(-4, 2);

is $z, 'tr';

