package autobox::Core;

use 5.8.0;

use strict;
use warnings;

our $VERSION = '0.1';

=pod

=head1 NAME

autobox::Core - Perl built-in functions exposed as methods in primitive types

=head1 SYNOPSIS

  use autobox;
  use autobox::Core;

  "Hello, World\n"->uc()->print();

=head1 DESCRIPTION

Methods wrapping F<perl>'s built-in functions for minipulating numbers, strings, arrays,
hashes, and code references. It is handy to use built-in functions as methods to avoid
messy dereferencing syntaxes and parenthesis pile ups. 

L<autobox> lets you call methods in scalars that aren't object references.
Numbers, strings, scalars containing numbers, scalars containing strings, 
array references, hash references, and code references all work as objects.
L<autobox> adds this feature to L<perl> but does not itself provide any
methods to call. That is left to the user or another module. For example,
this module.

F<autobox::Core> is what you'd call a I<stub> module. It is merely glue, presenting
existing functions with a new interface. Most of the methods read like
C<< sub hex ($) { hex($_[0]) } >>.
Besides built-ins that operate on hashes, arrays, scalars, and code references, 
some Perl 6-ish things were thrown in, and some keyword like C<foreach> have
been turned into methods.

=head3 What's Implemented?

All of the functions listed in L<perldoc> under the headings:
"Functions for real @ARRAYs",
"Functions for real %HASHes", 
"Functions for list data",
and "Functions for SCALARs or strings", plus a few taken from other sections
and documented below. 
Some things expected in Perl 6, such as C<last>, C<size>, and C<curry>, have been thrown in.

Of the built-in stuff, the things you use most often on data are all implemented. 
A small sample:

  print [10, 20, 30, 40, 50]->pop(), "\n";
  print [10, 20, 30, 40, 50]->shift(), "\n";

  my $arrref = [10, 20, 30];

  my $lala; 
  $lala = "Lalalalala\n"; print "chomp: ", $lala->chomp(), ' ', $lala, "\n";
  $lala = "Lalalalala\n"; print "lcfirst: ", $lala->lcfirst(), ' ', $lala, "\n";

  my $hashref = { foo => 10, bar => 20, baz => 30, qux => 40 };
  print "hash keys: ", join ' ', $hashref->keys(), "\n";

Besides those sections of L<perlfunc>, I've implemented
C<tie>,
C<tied>,
C<ref>,
C<undef>,
C<bless>,
and C<vec>, where they make sense. 
C<tie>, C<tied>, and C<undef> don't work on code references, and C<bless> doesn't work on non-reference
scalars.
C<quotemeta> works on non-reference scalars.

  my $arr = [ 1 .. 10 ];
  $arr->undef;

Array references can tell you how many elements they contain and the index of their last element:

  my $arr = [ 1 .. 10 ];
  print '$arr contains ', $arr->size, 
        ' elements, the last having an index of ', $arr->last, "\n";

Array references have an C<elements> method to dump their elements.
This is the same as C<< @{$array_ref} >>.

  my $arr = [ 1 .. 10 ];
  print join " -- ", $arr->elements, "\n";

Array references can be iterated on using C<for> and C<foreach>. Both take a code
reference as the body of the for statement. 
C<foreach> passes the current element itself in each pass.
C<for> passes the index of the current element in to that code block, and then
the current element, and then a reference to the array itself.


  my $arr = [ 1 .. 10 ];
  $arr->foreach(sub { print $_[0], "\n" });
  $arr->for(sub { die unless $_[1] == $_[2]->[$_[0]] });

C<sum> is a toy poke at doing L<Language::Functional>-like stuff:

  print $arrref->sum(), "\n";

If this goes over well, I'll make L<Langauge::Functional> a dependency and expose
its function as methods on the correct data types. Or maybe I will do this anyway.

C<each> is like C<foreach> but for hash references. For each key in the hash,
the code reference is invoked with the key and the corresponding value as arguments:

  my $hashref = { foo => 10, bar => 20, baz => 30, quux => 40 };
  $hashref->each(sub { print $_[0], ' is ', $_[1], "\n" });

There is currently no way to have the elements sorted before they are handed to the
code block. If someone requests a way of passing in a sort criteria, I'll implement it.

C<m> is C<< m// >> and C<s> is C<< s/// >>. These work on scalars.
Pass a regular expression created with C<< qr// >> and specify flags to the regular expression
as part of the regular expression using the C<< (?imsx-imsx) >> syntax documented in L<perlre>.
C<m> returns an array reference so that things such as C<map> and C<grep> may be called on the result.

  use autobox;
  use autobox::Core;

  my ($street_number, $street_name, $apartment_number) =
      "1234 Robin Drive #101"->m(qr{(\d+) (.*)(?: #(\d+))?})->elements;

  print "$street_number $street_name $apartment_number\n";

You may C<curry> code references:

  $adding_up_numbers = sub {
      my $first_number = shift;
      my $second_number = shift;
      return $first_number + $second_number;
  };

  my $adding_five_to_numbers = $adding_up_numbers->curry(5);

  $adding_five_to_numbers->(20)->print; "\n"->print;

That's it.

=head3 What's Missing?

Operators. I'm tired. I'll do it in the morning. Maybe. Send me a patch.

File and socket operations are already implemented in an object-oriented fashion
care of L<IO::Handle> and L<IO::Socket::INET>.
Functions listed in the L<perlfunc> headings "System V interprocess communication functions",
"Fetching user and group info",
"Fetching network info",
"Keywords related to perl modules",
"Functions for processes and process groups",
"Keywords related to scoping",
"Time-related functions",
"Keywords related to the control flow of your perl program",
"Functions for filehandles, files, or directories",
and 
"Input and output functions".
These things are likely implemented in an object oriented fashion by other CPAN
modules, are keywords and not functions,
take no arguments,
or don't make sense as part of the string, number, array, hash, or code API.
C<srand> because you probably shouldn't be using it. 
C<each> on hashes. There is no good reason it is missing.

=head1 EXAMPLE

=head1 BUGS

Yes. Report them to the author, L<scott@slowass.net>.
This code is not well tested.

=head1 SEE ALSO

L<autobox>. 

Perl 6: L<< http://dev.perl.org/perl6/apocalypse/ >>.

=head1 AUTHOR

Scott Walters, L<scott@slowass.net>
Thanks to chocolateboy for L<autobox> and for the encouragement!

=cut

#
# SCALAR
#

package SCALAR;

#       Functions for SCALARs or strings
#          "chomp", "chop", "chr", "crypt", "hex", "index", "lc",
#           "lcfirst", "length", "oct", "ord", "pack",
#           "q/STRING/", "qq/STRING/", "reverse", "rindex",
#           "sprintf", "substr", "tr///", "uc", "ucfirst", "y///"

# current doesn't handle scalar references - get can't call method chomp on unblessed reference etc when i try to support it

sub chomp   ($)   { CORE::chomp($_[0]); }
sub chop    ($)   { CORE::chop($_[0]); }
sub chr     ($)   { CORE::chr($_[0]); }
sub crypt   ($$)  { CORE::crypt($_[0], $_[1]); }
sub index   ($@)  { CORE::index($_[0], $_[1], @_[2.. $#_]); }
sub lc      ($)   { CORE::lc($_[0]); }
sub lcfirst ($)   { CORE::lcfirst($_[0]); }
sub length  ($)   { CORE::length($_[0]); }
sub ord     ($)   { CORE::ord($_[0]); }
sub pack    ($;@) { CORE::pack(@_); }
sub reverse ($)   { CORE::reverse($_[0]); }
sub rindex  ($@)  { CORE::rindex($_[0], $_[1], @_[2.. $#_]); }
sub sprintf ($@)  { CORE::sprintf($_[0], $_[1], @_[2.. $#_]); }
sub substr  ($@)  { CORE::substr($_[0], $_[1], @_[2 .. $#_]); }
sub uc      ($)   { CORE::uc($_[0]); }
sub ucfirst ($)   { CORE::ucfirst($_[0]); }
sub unpack  ($;@) { CORE::unpack(@_); }
sub quotemeta ($) { CORE::quotemeta($_[0]); }
sub vec     ($$$) { CORE::vec($_[0], $_[1], $_[2]); }
sub undef   ($)   { $_[0] = undef }
sub m       ($$)  { [ $_[0] =~ m{$_[1]} ] }
sub s       ($$$) { $_[0] =~ s{$_[1]}{$_[2]} }

#       Numeric functions
#           "abs", "atan2", "cos", "exp", "hex", "int", "log",
#           "oct", "rand", "sin", "sqrt", "srand"

sub abs     ($)  { CORE::abs($_[0]) }
sub atan2   ($)  { CORE::atan2($_[0], $_[1]) }
sub cos     ($)  { CORE::cos($_[0]) }
sub exp     ($)  { CORE::exp($_[0]) }
sub int     ($)  { CORE::int($_[0]) }
sub log     ($)  { CORE::log($_[0]) }
sub oct     ($)  { CORE::oct($_[0]) }
sub hex     ($)  { CORE::hex($_[0]); }
sub rand    ($)  { CORE::rand($_[0]) }
sub sin     ($)  { CORE::sin($_[0]) }
sub sqrt    ($)  { CORE::sqrt($_[0]) }

# doesn't minipulate scalars but works on scalars

sub print   ($;@) { print @_; }

#
# HASH
#

package HASH;

#       Functions for real %HASHes
#           "delete", "each", "exists", "keys", "values"

sub delete (\%@) { my $hash = CORE::shift; my @res = (); CORE::foreach(@_) { push @res, CORE::delete $hash->{$_}; } CORE::wantarray ? @res : $res[-1] }
sub exists (\%$) { my $hash = CORE::shift; CORE::exists $hash->{$_[0]}; }
sub keys (\%) { CORE::keys %{$_[0]} }
sub values (\%) { CORE::values %{$_[0]} }

# local

sub each (\%$) {
    my $hash = CORE::shift;
    my $cb = CORE::shift;
    while((my $k, my $v) = CORE::each(%$hash)) {
        $cb->($k, $v);
    }
}

#       Keywords related to classes and object-orientedness
#           "bless", "dbmclose", "dbmopen", "package", "ref",
#           "tie", "tied", "untie", "use"

sub bless (\%$)   { CORE::bless $_[0], $_[1] }
sub tie   (\%$;@) { CORE::tie   $_[0], @_[1 .. $#_] }
sub tied  (\%)    { CORE::tied  $_[0] }
sub ref   (\%)    { CORE::ref   $_[0] }

sub undef   ($)   { $_[0] = {} }

#
# ARRAY
#

package ARRAY;

#       Functions for list data
#           "grep", "join", "map", "qw/STRING/", "reverse",
#           "sort", "unpack"

sub grep (\@&) { my $arr = CORE::shift; my $sub = CORE::shift; CORE::grep { $sub->($_) } @$arr; }
sub join (\@$) { my $arr = CORE::shift; my $sep = CORE::shift; CORE::join $sep, @$arr; }
sub map (\@&) { my $arr = CORE::shift; my $sub = shift; CORE::map { $sub->($_) } @$arr; }
sub reverse (\@) { CORE::reverse @{$_[0]} }
sub sort (\@;&) { my $arr = CORE::shift; my $sub = CORE::shift() || sub { $a <=> $b }; CORE::sort { $sub->($a, $b) } @$arr; } 

# functionalish stuff

sub sum (\@) { my $arr = CORE::shift; my $res = 0; while(@$arr) { $res += shift @$arr; }; $res; }

#       Functions for real @ARRAYs
#           "pop", "push", "shift", "splice", "unshift"

sub pop (\@) { CORE::pop @{$_[0]}; }
sub push (\@;@) { my $arr = CORE::shift; CORE::push @$arr, @_; }
sub unshift (\@;@) { CORE::unshift @{$_[0]}, @_; }
sub exists (\@$) { my $arr = CORE::shift; CORE::exists $arr->[$_[0]] }
sub delete (\@$) { my $arr = CORE::shift; CORE::delete $arr->[$_[0]] }
sub shift (\@;@) { my $arr = CORE::shift; CORE::shift @$arr; } # last to prevent having to prefix normal shift calls with CORE::

sub undef   ($)   { $_[0] = [] }

# tied and blessed

sub bless (\@$)   { CORE::bless $_[0], $_[1] }
sub tie   (\@$;@) { CORE::tie   $_[0], @_[1 .. $#_] }
sub tied  (\@)    { CORE::tied  $_[0] }
sub ref   (\@)    { CORE::ref   $_[0] }

# perl 6-ish extensions to Perl 5 core stuff

sub last (\@) { my $arr = CORE::shift; $#$arr; }
sub size (\@) { my $arr = CORE::shift; CORE::scalar @$arr; }

# misc

sub foreach (\@$) { 
    my $arr = CORE::shift; my $sub = CORE::shift; 
    foreach my $i (@$arr) {
        $sub->($i);
    }
}

sub for (\@$) { 
    my $arr = CORE::shift; my $sub = CORE::shift; 
    for(my $i = 0; $i < $#$arr; $i++) {
        $sub->($i, $arr->[$i], $arr);
    }
}

# local

sub elements (\@) { ( @{$_[0]} ) }

#
# CODE
#

package CODE;

sub bless ($$)   { CORE::bless $_[0], $_[1] }
sub ref   ($)    { CORE::ref   $_[0] }

# perl 6-isms

sub curry (\&) { my $code = CORE::shift; my @args = @_; sub { CORE::unshift @_, @args; goto &$code; }; }

1;

__DATA__


       Regular expressions and pattern matching
           "m//", "pos", "quotemeta", "s///", "split", "study",
           "qr//"


       Functions for fixed length data or records
           "pack", "read", "syscall", "sysread", "syswrite",
           "unpack", "vec"


       Miscellaneous functions
           "defined", "dump", "eval", "formline", "local", "my",
           "our", "reset", "scalar", "undef", "wantarray"

       Keywords related to classes and object-orientedness
           "bless", "dbmclose", "dbmopen", "package", "ref",
           "tie", "tied", "untie", "use"




