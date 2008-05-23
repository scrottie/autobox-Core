package autobox::Core;

# XXX ARRAY and HASH should AUTOLOAD, and that AUTOLOAD should look for an array
# or hash element (double checking with exists) of that method name. This would
# allow for xmath's ` style dereferences, or javascript's arr.0 and hash.foo
# style dereferences. in perl, you could say $hashref->foo and $arrayref->5.
# okey, $arrayref->5 is invalid syntax. you'd have to say $five = 5; $arrayref->$five.
# hrm.
# on second thought, I think that's a different module.

# XXX support 'my IO::Handle $io; $io->open('<', $fn);'. undef values belonging to
# SVs having associated types should dispatch to that class. of course, just using
# core, this could be made to work too -- open() is a built-in, after all. the
# autobox::Core::open would have to know how to handle $_[0] being undef and 
# assigning the open'ed handle into $_[0].

use 5.8.0;

use strict;
use warnings;

our $VERSION = '0.5';

=pod

=head1 NAME

autobox::Core - Methods for core built-in functions in primitive types

=head1 SYNOPSIS

  use autobox;
  use autobox::Core;

  "Hello, World\n"->uc()->print();

=head1 DESCRIPTION

Methods wrapping F<perl>'s built-in functions for minipulating numbers, strings, arrays,
hashes, and code references. It can be handy to use built-in functions as methods to avoid
messy dereferencing syntaxes and parentheses pile ups.

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


=head2 What's Implemented?

All of the functions listed in L<perldoc> under the headings:
"Functions for real @ARRAYs",
"Functions for real %HASHes",
"Functions for list data",
and "Functions for SCALARs or strings", plus a few taken from other sections
and documented below.
Some things expected in Perl 6, such as C<last>, C<elems>, and C<curry>, have been thrown in.
For use in conjuction with L<Perl6::Contexts>, C<flatten> explicitly flattens an array.
Functions have been defined for numeric operations.

Of the built-in stuff, the things you use most often on data are all implemented.
Here's a small sample:

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
C<quotemeta> works on non-reference scalars, along with C<split>, C<m>, and C<s> for regular expression operations.

  my $arr = [ 1 .. 10 ];
  $arr->undef;

Array references can tell you how many elements they contain and the index of their last element:

  my $arr = [ 1 .. 10 ];
  print '$arr contains ', $arr->size,
        ' elements, the last having an index of ', $arr->last, "\n";

Array references have a C<flatten> method to dump their elements.
This is the same as C<< @{$array_ref} >>.

  my $arr = [ 1 .. 10 ];
  print join " -- ", $arr->flatten, "\n";

Under L<Perl6::Contexts>, you'll often need to write code equivalent to the follow:

  use Perl6::Contexts;
  use autobox;
  use autobox::Core;

  my @arr = ( 1 .. 10 );
  do_something(@arr->flatten);

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

  my ($street_number, $street_name, $apartment_number) =
      "1234 Robin Drive #101"->m(qr{(\d+) (.*)(?: #(\d+))?})->elements;

  print "$street_number $street_name $apartment_number\n";

C<split> is called on a non-reference scalar with the regular expression passed in. This is
done for consistency with C<m> and C<s>.

  print "10, 20, 30, 40"->split(qr{, ?})->elements, "\n";

You may C<curry> code references:

  $adding_up_numbers = sub {
      my $first_number = shift;
      my $second_number = shift;
      return $first_number + $second_number;
  };

  my $adding_five_to_numbers = $adding_up_numbers->curry(5);

  $adding_five_to_numbers->(20)->print; "\n"->print;

These work on numbers:

C<add>, C<and>, C<band>, C<bor>, C<bxor>, C<cmp>, C<dec>, C<div>, C<eq>, C<flip>, C<ge>, C<gt>, C<inc>, C<le>, C<lshift>, C<lt>, C<mod>, C<mult>, C<mcmp>, C<ne>, C<neg>, C<meq>, C<mge>, C<mgt>, C<mle>, C<mlt>, C<mne>, C<not>, C<or>, C<pow>, C<rpt>, C<rshift>, C<sub>, C<xor>.

That's it.

=head2 What's Missing?

Many operators.  I'm tired.  I'll do it in the morning.  Maybe.  Send me a patch.
Update:  Someone sent me a patch for numeric operations.

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
C<each> on hashes. 
There is no good reason it is missing.


=head2 Autoboxing

I<This section quotes four pages from the manuscript of Perl 6 Now: The Core Ideas Illustrated with Perl 5 by myself, Scott Walters. The text appears in the book starting at page 248. This copy lacks the benefit of copyedit - the finished product is of higher quality. See the shameless plug in the SEE ALSO section for information on ordering Perl 6 Now.>

A I<box> is an object that contains a primitive variable.
Boxes are used to endow primitive types with the capabilities of objects.
This is essential in strongly typed languages but never strictly required in Perl.
Programmers might write something like C<< my $number = Int->new(5) >>.
This is manual boxing.
To I<autobox> is to convert a simple type into an object type automatically, or only conceptually.
This is done by the language.
It makes a language look to programmers as if everything is an object while the interpreter
is free to implement data storage however it pleases.
Autoboxing is really making simple types such as numbers, strings, and arrays appear to be objects.

C<int>, C<num>, C<bit>, C<str>, and other types with lower case names, are primitives.
They're fast to operate on, and require no more memory to store than the data held strictly requires.
C<Int>, C<Num>, C<Bit>, C<Str>, and other types with an initial capital letter, are objects.
These may be subclassed (inherited from) and accept traits, among other things.
These objects are provided by the system for the sole purpose of representing primitive types as objects,
though this has many ancillary benefits such as making C<is> and C<has> work.
Perl provides C<Int> to encapsulate an C<int>, C<Num> to encapsulate a C<num>, C<Bit> to encapsulate a C<bit>, and so on.
As Perl's implementations of hashes and dynamically expandable arrays store any type, not just objects, Perl
programmers almost never are required to box primitive types in objects.
Perl's power makes this feature less essential than it is in other languages.

X<autobox>ing makes primitive objects and they're boxed versions equivalent.
An C<int> may be used as an C<Int> with no constructor call, no passing, nothing.
This applies to constants too, not just variables:

  # Perl 6 - autoboxing associates classes with primitives types:

  print 4.sqrt, "\n";

This is perfectly valid Perl 6.

All of this applies to hashes and arrays, as well:

  # Perl 6 - autoboxing associates classes with primitive types:

  print [ 1 .. 20 ].elems, "\n";

The language is free to implement data storage however it wishes but the programmer
sees the variables as objects.

Expressions using autoboxing read somewhat like Latin suffixes.
In the autoboxing mind-set, you might not say that something is "made more mnemonic",
but has been "mnemonicified".

Autoboxing may be mixed with normal function calls.
In the case where the methods are available as functions and the functions are
available as methods, it is only a matter of personal taste how the expression should be written:

  # Calling methods on numbers and strings, these three lines are equivalent
  # Perl 6

  print sqrt 4;
  print 4.sqrt;
  4.sqrt.print;

The first of these three equivalents assumes that a global C<sqrt()> function exists.
This first example would fail to operate if this global function were removed and only
a method in the C<Num> package was left.

Perl 5 had the beginnings of autoboxing with filehandles:

  use IO::Handle;
  open my $file, '<', 'file.txt' or die $!;
  $file->read(my $data, -s $file);

Here, C<read> is a method on a filehandle we opened but I<never blessed>.
This lets us say things like C<< $file->print(...) >> rather than the often ambagious

C<< print $file ... >>.
To many people, much of the time, it makes more conceptual sense as well.


=head3 Reasons to Box Primitive Types

What good is all of this?

=over 1

=item Makes conceptual sense to programmers used to object interfaces as I<the> way
to perform options.

=item Alternative idiom. Doesn't require the programmer
to write or read expressions with complex precedence rules or strange operators.

=item Many times that parenthesis would otherwise have to span a large expression, the expression
may be rewritten such that the parenthesis span only a few primitive types.

=item Code may often be written with fewer temporary variables.

=item Autoboxing provides the benefits of boxed types without the memory bloat of
actually using objects to represent primitives. Autoboxing "fakes it".

=item Strings, numbers, arrays, hashes, and so on, each have their own API.
Documentation for an C<exists> method for arrays doesn't have to explain how hashes are
handled and vice versa.

=item Perl tries to accommodate the notion that the "subject" of a statement
should be the first thing on the line, and autoboxing furthers this agenda.

=back

Perl is an idiomatic language and this is an important idiom.

=head3 Subject First: An Aside

Perl's design philosophy promotes the idea that the language should be flexible enough
to allow programmers to place the X<subject> of a statement first.
For example, C<< die $! unless read $file, 60 >> looks like the primary purpose of the statement is
to C<die>.
While that might be the programmers primary goal, when it isn't, the programmer
can communicate his real primary intention to programmers by reversing the order of
clauses while keeping the exact same logic: C<< read $file, 60 or die $! >>.
Autoboxing is another way of putting the subject first.
Nouns make good subjects, and in programming, variables, constants, and object names are the nouns.
Function and method names are verbs.
C<< $noun->verb() >> focuses the readers attention on the thing being acted on rather than the action being performed.
Compare to C<< $verb($noun) >>.


=head3 Autoboxing and Method Results

In Chapter 11 [Subroutines], we had examples of ways an expression could be
written.
Here it is again:

  # Various ways to do the same thing:

  print(reverse(sort(keys(%hash))));          # Perl 5 - pathological parenthetic
  print reverse sort keys %hash;              # Perl 5 - no unneeded parenthesis

  print(reverse(sort(%hash,keys))));          # Perl 6 - pathological
  print reverse sort %hash.keys;              # Perl 6 - no unneeded parenthesis

  %hash.keys ==> sort ==> reverse ==> print;  # Perl 6 - pipeline operator

  %hash.keys.sort.reverse.print;              # Perl 6 - autobox

  %hash->keys->sort->reverse->print;          # Perl 5 - autobox

This section deals with the last two of these equivalents.
These are method calls
  use autobox;
  use autobox::Core;
  use Perl6::Contexts;

  my %hash = (foo => 'bar', baz => 'quux');

  %hash->keys->sort->reverse->print;          # Perl 5 - autobox

  # prints "foo baz"

Each method call returns an array reference, in this example.
Another method call is immediately performed on this value.
This feeding of the next method call with the result of the previous call is the common mode
of use of autoboxing.
Providing no other arguments to the method calls, however, is not common.

F<Perl6::Contexts> recognizes object context as provided by C<< -> >> and
coerces C<%hash> into a reference, suitable for use with F<autobox>.
F<autobox> associates primitive types, such as references of various sorts, with classes.
F<autobox::Core> throws into those classes methods wrapping Perl's built-in functions.
In the interest of full disclosure, F<Perl6::Contexts> and F<autobox::Core> are my creations.


=head3 Autobox to Simplify Expressions

One of my pet peeves in programming is parenthesis that span large expression.
It seems like about the time I'm getting ready to close the parenthesis I opened
on the other side of the line, I realize that I've forgotten something, and I have to
arrow back over or grab the mouse.
When the expression is too long to fit on a single line, it gets broken up, then
I must decide how to indent it if it grows to 3 or more lines.

  # Perl 5 - a somewhat complex expression

  print join("\n", map { CGI::param($_) } @cgi_vars), "\n";
  # Perl 5 - again, using autobox:

  @cgi_vars->map(sub { CGI::param($_[0]) })->join("\n")->concat("\n")->print;

The autoboxed version isn't shorter, but it reads from left to right, and
the parenthesis from the C<join()> don't span nearly as many characters.
The complex expression serving as the value being C<join()>ed in the non-autoboxed version
becomes, in the autoboxed version, a value to call the C<join()> method on.

This C<print> statement takes a list of CGI parameter names, reads the values for
each parameter, joins them together with newlines, and prints them with a newline
after the last one.

Pretending that this expression were much larger and it had to be broken to span
several lines, or pretending that comments are to be placed after each part of
the expression, you might reformat it as such:

  @cgi_vars->map(sub { CGI::param($_[0]) })  # turn CGI arg names into values
           ->join("\n")                      # join with newlines
           ->concat("\n")                    # give it a trailing newline
           ->print;                          # print them all out

This could also have been written:

  sub { CGI::param($_[0]) }->map(@cgi_vars)  # turn CGI arg names into values
           ->join("\n")                      # join with newlines
           ->concat("\n")                    # give it a trailing newline
           ->print;                          # print them all out

C<map()> is X<polymorphic>.
The C<map()> method defined in the C<CODE> package takes for its arguments the things
to map.
The C<map()> method defined in the C<ARRAY> package takes for its argument a code reference
to apply to each element of the array.

I<Here ends the text quoted from the Perl 6 Now manuscript.>


=head1 BUGS

Yes. Report them to the author, L<scott@slowass.net>.
The API is not yet stable -- Perl 6-ish things and local extensions are still being renamed.


=head1 HISTORY

Version 0.5 has an $arrayref->unshift bug fix and and a new flatten method for hashes.
Also, this version is untested because my Hash::Util stopped working, dammit.

Version 0.4 got numeric operations, if I remember.

Version 0.3 fixes a problem where C<unpack> wasn't sure it had enough arguments
according to a test introduced in Perl 5.8.6 or perhaps 5.8.5.
This problem was reported by Ron Reidy - thanks Ron!
Version 0.3 also added the references to Perl 6 Now and the excerpt.

Version 0.2 rounded out the API and introduced the beginnings of functional-ish methods.

Version 0.1 was woefully incomplete.


=head1 SEE ALSO

=over 1

=item L<autobox>

=item L<Moose::Autobox>

=item L<Perl6::Contexts>

=item Perl 6: L<< http://dev.perl.org/perl6/apocalypse/ >>.

=item (Shameless plug:) I<Perl 6 Now: The Core Ideas Illustrated with Perl 5>
dedicates a sizable portion of Chapter 14, Objects, to autoboxing
and the idea is used heavily throughout the book. Chapter 8, Data Structures,
also has numerous examples.
See L<http://perl6now.com> or look for ISBN 1-59059-395-2 at your favorite
bookstore for more information.

=back


=head1 AUTHOR

Scott Walters, L<scott@slowass.net>.
Thanks to Matt Spear, who contributed tests and definitions for numeric operations.
Ricardo SIGNES contributed patches.
Mitchell N Charity reported a bug and sent a fix.
Thanks to chocolateboy for L<autobox> and for the encouragement.

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
sub unpack  ($;@) { CORE::unpack($_[0], @_[1..$#_]); }
sub quotemeta ($) { CORE::quotemeta($_[0]); }
sub vec     ($$$) { CORE::vec($_[0], $_[1], $_[2]); }
sub undef   ($)   { $_[0] = undef }
sub m       ($$)  { [ $_[0] =~ m{$_[1]} ] }
sub nm       ($$)  { [ $_[0] !~ m{$_[1]} ] }
sub s       ($$$) { $_[0] =~ s{$_[1]}{$_[2]} }
sub split   ($$)  { [ split $_[1], $_[0] ] }

sub eval    ($)   { CORE::eval "$_[0]"; }
sub system  ($;@) { CORE::system @_; }
sub backtick($)   { `$_[0]`; }

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

# functions for array creation
sub to ($$) { $_[0] < $_[1] ? [$_[0]..$_[1]] : [CORE::reverse $_[1]..$_[0]]}
sub upto ($$) { [ $_[0]..$_[1] ] }
sub downto ($$) { [ CORE::reverse $_[1]..$_[0] ] }

# just weird, but cool
sub times ($&) { for (0..$_[0]-1) { $_[1]->($_); }; $_[0]; }

# doesn't minipulate scalars but works on scalars

sub print   ($;@) { CORE::print @_; }
sub say     ($;@) { CORE::print @_, "\n"}

# operators that work on scalars:

sub concat ($;@)   { CORE::join '', @_; }

# operator schizzle
sub add($$) { $_[0] + $_[1]; }
sub and($$) { $_[0] && $_[1]; }
sub band($$) { $_[0] & $_[1]; }
sub bor($$) { $_[0] | $_[1]; }
sub bxor($$) { $_[0] ^ $_[1]; }
sub cmp($$) { $_[0] cmp $_[1]; }
sub dec($) { my $t = CORE::shift @_; --$t; }
sub div($$) { $_[0] / $_[1]; }
sub eq($$) { $_[0] eq $_[1]; }
sub flip($) { ~$_[0]; }
sub ge($$) { $_[0] ge $_[1]; }
sub gt($$) { $_[0] gt $_[1]; }
sub inc($) { my $t = CORE::shift @_; ++$t; }
sub le($$) { $_[0] le $_[1]; }
sub lshift($$) { $_[0] << $_[1]; }
sub lt($$) { $_[0] lt $_[1]; }
sub mod($$) { $_[0] % $_[1]; }
sub mult($$) { $_[0] * $_[1]; }
sub mcmp($$) { $_[0] <=> $_[1]; }
sub ne($$) { $_[0] ne $_[1]; }
sub neg($) { -$_[0]; }
sub meq($$) { $_[0] == $_[1]; }
sub mge($$) { $_[0] >= $_[1]; }
sub mgt($$) { $_[0] > $_[1]; }
sub mle($$) { $_[0] <= $_[1]; }
sub mlt($$) { $_[0] < $_[1]; }
sub mne($$) { $_[0] != $_[1]; }
sub not($) { !$_[0]; }
sub or($$) { $_[0] || $_[1]; }
sub pow($$) { $_[0] ** $_[1]; }
sub rpt($$) { $_[0] x $_[1]; }
sub rshift($$) { $_[0] >> $_[1]; }
sub sub($$) { $_[0] - $_[1]; }
sub xor($$) { $_[0] ^ $_[1]; }

#
# HASH
#

package HASH;

#       Functions for real %HASHes
#           "delete", "each", "exists", "keys", "values"

sub delete (\%@) { my $hash = CORE::shift; my @res = (); CORE::foreach(@_) { push @res, CORE::delete $hash->{$_}; } CORE::wantarray ? @res : \@res }
sub exists (\%$) { my $hash = CORE::shift; CORE::exists $hash->{$_[0]}; }
sub keys (\%) { [ CORE::keys %{$_[0]} ] }
sub values (\%) { [ CORE::values %{$_[0]} ] }

sub at (\%@) { $_[0]->{@_[1..$#_]}; }
sub get(\%@) { $_[0]->{@_[1..$#_]}; }
sub put(\%%) { my $h = CORE::shift @_; my %h = @_; while(my ($k, $v) = CORE::each %h) { $h->{$k} = $v; }; $h; }
sub set(\%%) { my $h = CORE::shift @_; my %h = @_; while(my ($k, $v) = CORE::each %h) { $h->{$k} = $v; }; $h; }

sub flatten(\%) { %{$_[0]} }

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

# okey, ::Util stuff should be core

use Hash::Util;

sub lock_keys (\%) { Hash::Util::lock_keys(%{$_[0]}); $_[0]; }

#
# ARRAY
#
##############################################################################################
package ARRAY;

#       Functions for list data
#           "grep", "join", "map", "qw/STRING/", "reverse",
#           "sort", "unpack"

sub grep (\@&) { my $arr = CORE::shift; my $sub = CORE::shift; [ CORE::grep { $sub->($_) } @$arr ]; }
sub join (\@$) { my $arr = CORE::shift; my $sep = CORE::shift; CORE::join $sep, @$arr; }
sub map (\@&) { my $arr = CORE::shift; my $sub = shift; [ CORE::map { $sub->($_) } @$arr ]; }
sub reverse (\@) { [ CORE::reverse @{$_[0]} ] }
sub sort (\@;&) { my $arr = CORE::shift; my $sub = CORE::shift() || sub { $a cmp $b }; [ CORE::sort { $sub->($a, $b) } @$arr ]; }

# functionalish stuff

sub sum (\@) { my $arr = CORE::shift; my $res = 0; $res += $_ foreach(@$arr); $res; }
sub mean(\@) { my $arr = CORE::shift; my $res = 0; $res += $_ foreach(@$arr); $res/@$arr; }
sub var(\@)
{
	my $arr = CORE::shift;
	my $mean = 0;
	$mean += $_ foreach(@$arr);
	$mean /= @$arr;
	my $res = 0;
	$res += ($_-$mean)**2 foreach (@$arr);
	$res/@$arr;
}
sub svar(\@)
{
	my $arr = CORE::shift;
	my $mean = 0;
	$mean += $_ foreach(@$arr);
	$mean /= @$arr;
	my $res = 0;
	$res += ($_-$mean)**2 foreach (@$arr);
	$res/(@$arr-1);
}

sub max(\@) { my $arr = CORE::shift; my $max = $arr->[0]; foreach (@$arr) {$max = $_ if $_ > $max }; $max; }
sub min(\@) { my $arr = CORE::shift; my $min = $arr->[0]; foreach (@$arr) {$min = $_ if $_ < $min }; $min; }

#       Functions for real @ARRAYs
#           "pop", "push", "shift", "splice", "unshift"

sub pop (\@) { CORE::pop @{$_[0]}; }
sub push (\@;@) { my $arr = CORE::shift; CORE::push @$arr, @_;  $arr; }
sub unshift (\@;@) { my $a = CORE::shift; CORE::unshift(@$a, @_); $a; }
sub delete (\@$) { my $arr = CORE::shift; CORE::delete $arr->[$_[0]] }
sub vdelete(\@$) { my $arr = CORE::shift; @$arr = CORE::grep {$_ ne $_[0]} @$arr; }
sub shift (\@;@) { my $arr = CORE::shift; CORE::shift @$arr; } # last to prevent having to prefix normal shift calls with CORE::

sub undef   ($)   { $_[0] = [] }

# doesn't modify array
sub exists (\@$) { my $arr = CORE::shift; CORE::scalar(CORE::grep {$_ eq $_[0]} @$arr) > 0; }
sub at(\@$) { my $arr = CORE::shift; $arr->[$_[0]]; }
sub count(\@$) { my $arr = CORE::shift; scalar(CORE::grep {$_ eq $_[0]} @$arr); }
sub uniq(\@) { my $arr = CORE::shift; my %h; [ CORE::map { $h{$_}++ == 0 ? $_ : () } @$arr ] } # shamelessly from List::MoreUtils

# tied and blessed

sub bless (\@$)   { CORE::bless $_[0], $_[1] }
sub tie   (\@$;@) { CORE::tie   $_[0], @_[1 .. $#_] }
sub tied  (\@)    { CORE::tied  $_[0] }
sub ref   (\@)    { CORE::ref   $_[0] }

# perl 6-ish extensions to Perl 5 core stuff

sub first(\@) { my $arr = CORE::shift; $arr->[0]; }
sub last (\@) { my $arr = CORE::shift; $#$arr; }
sub size (\@) { my $arr = CORE::shift; CORE::scalar @$arr; }
sub elems (\@) { my $arr = CORE::shift; CORE::scalar @$arr; } # Larry announced it would be elems, not size
sub length (\@) { my $arr = CORE::shift; CORE::scalar @$arr; }

# misc

sub each (\@$) {
    # same as foreach(), apo12 mentions this
    my $arr = CORE::shift; my $sub = CORE::shift;
    foreach my $i (@$arr) {
        $sub->($i);
    }
}

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

sub print   (\@) { my $arr = CORE::shift; my @arr = @$arr; CORE::print "@arr"; }
sub say   (\@) { my $arr = CORE::shift; my @arr = @$arr; CORE::print "@arr\n"; }

# local

sub elements (\@) { ( @{$_[0]} ) }
sub flatten (\@) { ( @{$_[0]} ) }

##############################################################################################

#
# CODE
#

package CODE;

sub bless ($$)   { CORE::bless $_[0], $_[1] }
sub ref   ($)    { CORE::ref   $_[0] }

# perl 6-isms

sub curry (\&) { my $code = CORE::shift; my @args = @_; sub { CORE::unshift @_, @args; goto &$code; }; }

# local - polymorphic

sub map (&@) { my $code = CORE::shift; [ CORE::map { $code->($_) } @_ ]; }

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




# XXX array.random
