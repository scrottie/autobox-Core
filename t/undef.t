use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

my $foo = 'foo';
is $foo->undef, undef;

is_deeply [1,2,3]->undef, [];
is_deeply {foo => 123}->undef, +{};
