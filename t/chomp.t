use Test::More qw(no_plan);

use autobox::Core;

my $line = "This has a new line\n";

$line->chomp;

is $line, "This has a new line";

