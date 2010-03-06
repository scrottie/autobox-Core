use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

is_deeply ["hi there"->split(qr/ */)], [qw(h i t h e r e)];

my $arrayref = "hi there"->split(qr/ */);

is ref $arrayref, 'ARRAY', "Returns arrayref in scalar context";

