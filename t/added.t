use Test::More 'no_plan';
use autobox::Core;

#####################################################################
# Load
#####################################################################
ok(1);

#####################################################################
# Scalar
#####################################################################
ok(1->and(5));
ok(!1->and(0));

my $int_to_dec = 1;
$int_to_dec->dec;
is $int_to_dec, 0, 'decremented an int';

my $int_to_inc = 1;
$int_to_inc->inc;
is $int_to_inc, 2, 'incremented an int';

ok(5->mod(2) == 1);

ok(1->neg == -1);

ok(not 1->not);

ok(1->or(5));

ok(2->pow(5) == 32);

ok(1->rpt(5) eq '11111');

ok(1->xor(5) == 0);

ok("1+5"->eval() == 6);

ok("echo test"->backtick =~ "test");
ok("echo test"->qx =~ "test");   # qx as an alias to backtick per #16

my $a = 1->to(10);
ok($a->[0] == 1 && $a->[@$a-1] == 10);
$a = 10->to(1);
ok($a->[0] == 10 && $a->[@$a-1] == 1);
my @a = 1->to(10);
is_deeply \@a, [ 1 .. 10 ];

$a = 1->upto(10);
ok($a->[0] == 1 && $a->[@$a-1] == 10);

@a = 1->upto(10);
is_deeply \@a, [ 1 .. 10 ];

$a = 10->downto(1);
ok($a->[0] == 10 && $a->[@$a-1] == 1);

@a = 10->downto(1);
is_deeply \@a, [ reverse 1 .. 10 ];

#####################################################################
# Hashes
#####################################################################
my $h = {a => 1, b => 2, c => 3};
is($h->at('b'), 2);

is($h->get('c'), 3);

$h->put('d' => 4, e=>5, f=>6);
is($h->get('e'), 5);
$h->put('g', 7);
is($h->get('g'), 7);

$h->set('h' => 8);
is($h->get('h'), 8);
$h->set('i', 9);
is($h->get('i'), 9);

is_deeply [$h->get(qw(a b c))], [1, 2, 3];

is_deeply(
  [ sort $h->flatten ],
  [ sort %$h ],
  "flattening gets us all the contents",
);

#####################################################################
# Array
#####################################################################
$a = 1->to(10);
ok($a->sum == 55);
ok($a->[0] == 1);

ok($a->mean == 55/10);

ok($a->var == 33/4);

ok($a->svar == 55/6);

ok($a->max == 10);

ok($a->min == 1);

ok($a->exists(5));
ok(not $a->exists(11));

$a = $a->map(sub {int($_/2)});
ok($a->exists(3));
$a->vdelete(3);
ok(not $a->exists(3));

ok($a->at(0) == 0);

ok($a->count(4) == 2);

$a = $a->uniq;
ok($a->count(1) == 1 && $a->count(4) == 1);

ok($a->first == 0);
ok($a->first(sub { m/4/ }) == 4);
ok($a->first(qr/4/) == 4);

$a = 1->to(10);
$a->unshift(100);
ok($a->sum == 155);





