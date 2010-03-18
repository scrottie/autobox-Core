use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

my $h = {a => 1, b => 2, c => 3};
my %h = %$h;

my @slice = $h->slice(qw(a c));
is_deeply(\@slice, [ 1, 3 ]);
my $slice = $h->slice(qw(b c));
is_deeply($slice, [ 2, 3 ]);
@slice = %h->slice(qw(a c));
is_deeply(\@slice, [ 1, 3 ]);
$slice = %h->slice(qw(b c));
is_deeply($slice, [ 2, 3 ]);

