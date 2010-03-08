use Test::More qw(no_plan);
use strict;
use warnings;

use autobox::Core;

my $message = "This is an important message";
my @array   = qw(this is an important message);

SKIP: {
    my $has_test_output = eval { require Test::Output };

    skip "Don't have Test::Output", 2, if not $has_test_output;
    Test::Output::stdout_is( sub { $message->print }, $message );
    Test::Output::stdout_is( sub { @array->print }, "@array" );
}

# We need at least one test so that Test::Harness doesn't complain in
# case we had to skip above

ok 1;

