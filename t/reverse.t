use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

is "Hello"->reverse, "olleH";

my @list = qw(foo bar baz);

is_deeply [@list->reverse], [qw(baz bar foo)];

my $arrayref = @list->reverse;

is ref $arrayref, "ARRAY", "returns an arrayref in scalar context";

