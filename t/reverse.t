use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

# https://github.com/schwern/perl5i/issues/182
my $scalar = 'foo';
my($reverse) = $scalar->reverse;  # list context
is $reverse, 'oof', 'reverse in list context reverses the scalar';
is scalar $scalar->reverse, 'oof', 'reverse in scalar context reverses the scalar';

is "Hello"->reverse, "olleH";

my @list = qw(foo bar baz);

is_deeply [@list->reverse], [qw(baz bar foo)];

my $arrayref = @list->reverse;

is ref $arrayref, "ARRAY", "returns an arrayref in scalar context";

