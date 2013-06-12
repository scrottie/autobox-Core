use strict;
use warnings;
use Test::More tests => 7;
use autobox::Core;

is "Hello, World\n"->uc, "HELLO, WORLD\n";

my @list = (1, 5, 9, 2, 0, 4, 2, 1);
is_deeply [@list->sort->reverse], [9,5,4,2,2,1,1,0]; 

# works with references too!
my $list = [1, 5, 9, 2, 0, 4, 2, 1];
is_deeply [$list->sort->reverse], [9,5,4,2,2,1,1,0];

my %hash = (
      grass => 'green',
      apple => 'red',
      sky   => 'blue',
);

is [10, 20, 30, 40, 50]->pop, 50;
is [10, 20, 30, 40, 50]->shift, 10;

my $lala = "Lalalalala\n"; 
is "chomp: "->concat($lala->chomp, " ", $lala), "chomp: 1 Lalalalala";

my $hashref = { foo => 10, bar => 20, baz => 30, qux => 40 };

is $hashref->keys->sort->join(' '), "bar baz foo qux";

