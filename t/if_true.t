use Test::More tests => 3;
use strict;
use warnings;

use autobox::Core;

subtest 'test_one_branch' => sub {
    my (@evens, @odds);

    my $x = 5;
    my $y = 4;

    ($x % 2 == 0)->if_false( sub { push @odds, $x } );
    ($x % 2 == 0)->if_true ( sub { push @odds, $x } );

    ($y % 2 == 0)->if_true ( sub { push @evens, $y } );
    ($y % 2 == 0)->if_false( sub { push @evens, $y } );

    is_deeply
        [ \@odds, \@evens ],
        [ [5], [4] ];
};

subtest 'test_if_true_both_branches' => sub {
    my (@evens, @odds);

    my $x = 5;
    my $y = 4;

    ($x % 2 == 0)->if_true(
        sub { push @evens, $x },
        else => sub { push @odds, $x },
    );
    ($y % 2 == 0)->if_true(
        sub { push @evens, $y },
        else => sub { push @odds, $y },
    );

    is_deeply
        [ \@odds, \@evens ],
        [ [5], [4] ];
};

subtest 'test_if_false_both_branches' => sub {
    my (@evens, @odds);

    my $x = 4;
    my $y = 5;

    ($x % 2 == 0)->if_false(
        sub { push @odds, $x },
        else => sub { push @evens, $x },
    );
    ($y % 2 == 0)->if_false(
        sub { push @odds, $y },
        else => sub { push @evens, $y },
    );

    is_deeply
        [ \@odds, \@evens ],
        [ [5], [4] ];
};
