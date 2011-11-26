package autobox::Core;

# TODO:

# o. Lars D implemented a times() method for scalars but there is no doc or comment and I don't see the point; commented it out for now.
#    (scrottie)
# o. @array->random ?
# o. "5->times(sub { print "hi\n"}); # XXX likely to change but it's in the code so bloody doc it so I have incentive to rethink it". 
#    well?  do we want this?  (scrottie)
# o. kill head() and tail() -- does it really make sense to try to emulate linked lists with Perl arrays?  cute idea, but, uh. (scrottie)
# o. "There's currently no counterpart to the C<< \ >> operator" -- but should we back away from trying to name operators and
#    only do built-in functions? (scrottie)
# o. I no longer think that center() belongs here; plenty of modules offer text formatting (scrottie)
# o. don't overlap with autobox::List::Util.  or else do.  but decide.
# o. make jive with MooseX::Autobox or whatever it is
# v/ regenerate README
# o. steal perl5i's docs too
# o. IO::Any?
# o. "appending the user-supplied arguments allows autobox::Core options to be overridden" -- document this if we haven't already
# v/ more Hash::Util methods?
# o. "If this goes over well, I'll make L<Langauge::Functional> a dependency and expose its function as methods on the correct data types. Or maybe I will do this anyway."
#    ... maybe there should be filter, fold, reduce, etc methods
# o. support 'my IO::Handle $io; $io->open('<', $fn);'. undef values belonging to
#   SVs having associated types should dispatch to that class. of course, just using
#   core, this could be made to work too -- open() is a built-in, after all. the
#   autobox::Core::open would have to know how to handle $_[0] being undef and
#   assigning the open'ed handle into $_[0].

#
# from http://search.cpan.org/~miyagawa/PSGI-1.03/PSGI/FAQ.pod:
#
# body.each { |buf| request.write(buf) }
#
#would just magically work whether body is an Array, FileIO object or an object that implements iterators. Perl doesn't have such a beautiful thing in the language unless autobox is loaded. PSGI should not make autobox as a requirement, so we only support a simple array ref or file handle.
#
# ... perl5i should unify interfaces to IO handles, arrays, hashes, objects, etc as much as possible.


use 5.008;

use strict;
use warnings;

our $VERSION = '1.21';

use base 'autobox';

use B;

# appending the user-supplied arguments allows autobox::Core options to be overridden
# or extended in the same statement e.g.
#
#    use autobox::Core UNDEF     => 'MyUndef';          # also autobox undef
#    use autobox::Core CODE      =>  undef;             # don't autobox CODE refs
#    use autobox::Core UNIVERSAL => 'Data::Dumper';     # enable a Dumper() method for all types

sub import {
    shift->SUPER::import(DEFAULT => 'autobox::Core::', @_);
}

=encoding UTF-8

=head1 NAME

autobox::Core - Core functions exposed as methods in primitive types

=head1 SYNOPSIS

  use autobox::Core;

  "Hello, World\n"->uc->print;

=head1 DESCRIPTION

The L<autobox> module lets you call methods on primitive datatypes such as
scalars and arrays.

L<autobox::CORE> defines methods for core operations such as C<join>, C<print>,
most everything in L<perlfunc>, some things from L<Scalar::Util> and
L<List::Util>, and some Perl 5 versions of methods taken from Perl 6.

These methods expose as methods the built-in functions for minipulating
numbers, strings, arrays, hashes, and code references.

It can be handy to use built-in functions as methods to avoid
messy dereferencing syntaxes and parentheses pile ups.

F<autobox::Core> is what you'd call a I<stub> module. It is mostly glue, presenting
existing functions with a new interface. Most of the methods read like
C<< sub hex { hex($_[0]) } >>.
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
Methods from L<Scalar::Util> and L<List::Util> were thrown in.
Some things expected in Perl 6, such as C<last> (C<last_idx>), C<elems>, and C<curry>, have been thrown in.
C<flatten> explicitly flattens an array.
Functions such as C<add> have been defined for numeric operations.

Here's a small sample:

  print [10, 20, 30, 40, 50]->pop, "\n";
  print [10, 20, 30, 40, 50]->shift, "\n";

  my $arrref = [10, 20, 30];

  my $lala;
  $lala = "Lalalalala\n"; print "chomp: ", $lala->chomp, ' ', $lala, "\n";
  $lala = "Lalalalala\n"; print "lcfirst: ", $lala->lcfirst, ' ', $lala, "\n";

  my $hashref = { foo => 10, bar => 20, baz => 30, qux => 40 };

  print "hash keys: ", $hashref->keys->join(' '), "\n"; # or if you prefer...
  print "hash keys: ", join ' ', $hashref->keys(), "\n";

Of the built-in stuff, only a few stragglers such as C<srand> were excluded.


=head3 String Methods


=head4 concat

C<concat> corresponds to C<.> operator used to join two strings.

=head4 strip

C<strip> is not a built-in operator or function but is instead one of a number of user-defined
convenience methods.
C<strip> strips out whitespace from the beginning and end of a string.
This is redundant and subtly different from C<trim> XXX.

   " \t  \n  \t  foo  \t  \n  \t  "->strip;		# foo
   
=head4 trim

C<trim> strips out whitespace from the beginning and end of a string.
C<trim> can also removes specific characters from beginning and the end of string.

   '    hello'->trim;			# testme
   '--> hello <--'->trim("-><");  	# testme 
   ' --> hello <--'->trim("-><");  	# --> testme 

=head4 split

C<split> is called on a non-reference scalar with the regular expression passed in. This is
done for consistency with C<m> and C<s>. 

   print "10, 20, 30, 40"->split(qr{, ?})->elements, "\n";
   "hi there"->split(qr/ */);		# h i t h e r e
   
C<Caveat> 
  
Works just like L<split|perlfunc/split> which is called as split(/pattern/, $string, $limit); 
but the regex must be passed in as a C<qr//> compiled regex in C<split>
It also does not take a limit on the number of times to split.   

=head4 title_case

C<title_case> converts the first character of each word in the string to upper case.
  
   "this is a test"->title_case;	# This Is A Test
   
=head4 center

    my $centered_string = $string->center($length);
    my $centered_string = $string->center($length, $character);

Centers $string between $character.  $centered_string will be of
length $length.

C<$character> defaults to " ".

    say "Hello"->center(10);        # "   Hello  ";
    say "Hello"->center(10, '-');   # "---Hello--";

C<center()> will never truncate C<$string>.  If $length is less
than C<< $string->length >> it will just return C<$string>.

    say "Hello"->center(4);        # "Hello";   

=head4 ltrim

   my $trimmed_string = $string->ltrim;
   my $trimmed_string = $string->ltrim($characters);
   
C<ltrim> removes spaces or specific characters from the left of the string and 
returns the modified string.

   '    hello'->ltrim;			# 'hello'
   '--> hello <--'->ltrim("-><");	# ' hello <--'

=head4 rtrim

   my $trimmed_string = $string->ltrim;
   my $trimmed_string = $string->ltrim($characters);
   
C<rtrim> is same as C<ltrim> but removes spaces/characters from teh right of the
string.

   '    hello '->rtrim;			# '    hello'
   '--> hello <--'->rtrim("-><");	# '--> hello '

=head4 backtick

C<backtick> returns what is sent to STDOUT. It runs a command and returns the 
command's output.

=head4 nm

C<nm> corresponds to C<< !~ >>.

=head4 m

C<m> is C<< m// >>. 
C<< $foo->m(/bar/) >> corresponds to C<< $foo =~ m/bar/ >>.

=head4 s

C<s> is C<< s/// >>.

To use C<m> and C<s>, pass a regular expression created with C<< qr// >> and specify its flags
as part of the regular expression using the C<< (?imsx-imsx) >> syntax documented in L<perlre>.
C<m> returns an array reference so that things such as C<map> and C<grep> may be called on the result.

  my ($street_number, $street_name, $apartment_number) =
      "1234 Robin Drive #101"->m(qr{(\d+) (.*)(?: #(\d+))?})->elements;

  print "$street_number $street_name $apartment_number\n";

=head4 undef

C<undef> assigns C<undef> to the value.

=head4 defined

C<defined> tests whether a value is defined (not C<undef>).

These built in functions are implemented for scalars, they work just like normal:
L<chomp|perlfunc/chomp>, L<chop|perlfunc/chop>,L<chr|perlfunc/chr>
L<crypt|perlfunc/crypt>, L<index|perlfunc/index>, L<lc|perlfunc/lc>
L<lcfirst|perlfunc/lcfirst>, L<length|perlfunc/length>, L<ord|perlfunc/ord>,
L<pack|perlfunc/pack>, L<reverse|perlfunc/reverse>, L<rindex|perlfunc/rindex>,
L<sprintf|perlfunc/sprintf>, L<substr|perlfunc/substr>, L<uc|perlfunc/uc>
L<ucfirst|perlfunc/ucfirst>, L<unpack|perlfunc/unpack>, L<quotemeta|perlfunc/quotemeta>,
L<vec|perlfunc/vec>, L<undef|perlfunc/undef>, L<m|perlfunc/m>, L<nm|perlfunc/nm>,
L<s|perlfunc/s>, L<split|perlfunc/split>, L<system|perlfunc/system>, L<eval|perlfunc/eval>.


=head3 I/O Methods

=head4 print

C<print> prints a string or a list of strings. Returns true if successful.

=head4 say

C<say> is like print, but implicitly appends a newline.


=head3 Number Related Methods

The basic built in functions which operate as normal :
L<abs|perlfunc/abs>, L<atan2|perlfunc/atan2>, L<cos|perlfunc/cos>, L<exp|perlfunc/exp>,
L<int|perlfunc/int>, L<log|perlfunc/log>, L<oct|perlfunc/oct>, L<hex|perlfunc/hex>,
L<rand|perlfunc/rand>, L<sin|perlfunc/sin>, and L<sqrt|perlfunc/sqrt> are named after
the built-in functions of the same name.

Operators were given names as follows:  

=head4 add

C<add> corresponds to C<+>.

=head4 and

C<and> corresponds to C<&&> .

=head4 band

C<band> corresponds to C<&> that is short-circuit and.

=head4 bor

C<bor> corresponds to C<|> that is short-circuit or.

=head4 bxor

C<bxor> corresponds to C<^> that is short-circuit xor.

=head4 cmp

C<cmp> is compare operator which returns 0, 1, -1 depending upon first number 
is =, >, < the second respectively.

=head4 dec

C<dec> returns the decimal part of a number.

=head4 div

C<div> returns the quotient of division.

=head4 eq

C<eq> returns true if the values are equal.

   1->eq(5);		#false
   6->eq(6);		#true
   
=head4 flip

C<flip> corresponds to C<~> which is the binary (rather than boolean) "not".   

=head4 ge

C<ge> corresponds to  C<< >= >>.

=head4 gt

C<gt> corresponds to C<< > >>.

=head4 inc

C<inc> corresponds to C<++>.

=head4 le

C<le> corresponds to C<< <= >>. 

=head4 lshift

C<lshift> corresponds to C<< << >>.

=head4 lt

C<lt> corresponds to C<< < >>.

=head4 mod
 
C<mod> corresponds to C<%>.

=head4 mult

C<mult> corresponds to C<*>.

=head4 mcmp

C<mcmp> compares two numbers and returns 0,1,-1 depending upon the type of input.

   1->mcmp(5); 		# < 0
   5->mcmp(5); 		# = 0	
   6->mcmp(5);		# > 0
   
=head4 ne
   
C<ne> corresponds to C<!=>.

=head4 nge

C<nge> stands for numeric greater than or equal to that is C<< >= >>.
   
=head4 meq
   
m may stand for 'math'.   
C<meq> corresponds to C<==> operator. 

=head4 mge

C<mge> corresponds to C<< >= >> .

=head4 mgt

C<mgt> corresponds to C<< > >>.

=head4 mle

C<mle> corresponds to C<< <= >> .

=head4 mlt

C<mlt> corresponds to C<< < >>.

=head4 mne

C<mne> corresponds to C<!=> operator.

=head4 not

C<not> corresponds to C<!>.

=head4 or

C<or> corresponds to C<||>.

=head4 pow

C<pow> returns first number raised to the power of second.

=head4 rpt

C<rpt> repeats a specific digit a particular number of times.

   1->rpt(5);		# 11111
   
=head4 rshift
   
C<rshift> corresponds to C<<< >> >>>.

=head4 sub

C<sub> corresponds to C<->.

=head4 xor

C<xor> corresponds to <^>.

Numerical functions :

=head4 is_number

    $is_a_number = $thing->is_number;

Returns true if $thing is a number as understood by Perl.

    12.34->is_number;           # true
    "12.34"->is_number;         # also true

=head4 is_positive

    $is_positive = $thing->is_positive;

Returns true if $thing is a positive number.

C<0> is not positive.

=head4 is_negative

    $is_negative = $thing->is_negative;

Returns true if $thing is a negative number.

C<0> is not negative.

=head4 is_integer

    $is_an_integer = $thing->is_integer;

Returns true if $thing is an integer.

    12->is_integer;             # true
    12.34->is_integer;          # false

=head4 is_int

A synonym for is_integer.

=head4 is_decimal

    $is_a_decimal_number = $thing->is_decimal;

Returns true if $thing is a decimal number.

    12->is_decimal;             # false
    12.34->is_decimal;          # true
    ".34"->is_decimal;          # true


=head3 Reference Related Methods

Besides the "Functions for SCALARs" section of L<perlfunc>, the following were implemented, where they
make sense:

L<tie|perlfunc/tie>, L<tied|perlfunc/tied>, L<ref|perlfunc/ref>, 
L<undef|perlfunc/undef>, L<bless|perlfunc/bless>, L<vec|perlfunc/vec>.

C<tie>, C<tied>, and C<undef> don't work on code references.

=head4 bless

Attempting to C<bless> a non-reference scalar will fail with one of:
'Can't call method "bless" on an undefined value' or
'Can't call method "bless" without a package or object reference'
Hashes, arrays and scalars containing references may be blessed.
Here's an example of blessing a hash:

    use autobox::Core;
    my %foo;
    sub mypackage::hi { print "hi\n"; };
    %foo->bless('mypackage');
    %foo->hi;  
    
It is technically true that only references may be blessed.  This works because C<perl>, internally, stores
references to lexical variables in the current scope, much like globs hold references to package variables.
The reference in the "pad" (array of lexical variables for the current stack frame) is blessed in this example.

=head4 quotemeta

C<quotemeta> works on non-reference scalars, along with C<split>, C<m>, and C<s> for regular expression operations.
C<ref> is the same as the C<ref> keyword in that it tells you what kind of a reference something is if it's a
reference.

There's currently no counterpart to the C<< \ >> operator, which takes something and gives you
a reference to it.



=head3 Array Methods

Array methods work on both arrays and array references:

  my $arr = [ 1 .. 10 ];
  $arr->undef;

Or:

  my @arr = [ 1 .. 10 ];
  @arr->undef;

These built-in functions are defined as methods:

L<pop|perlfunc/pop>, L<push|perlfunc/push>, L<shift|perlfunc/shift>,
L<unshift|perlfunc/unshift>, L<delete|perlfunc/delete>, 
L<undef|perlfunc/undef>, L<exists|perlfunc/exists>,
L<bless|perlfunc/bless>, L<tie|perlfunc/tie>, L<tied|perlfunc/tied>, L<ref|perlfunc/ref>,
L<grep|perlfunc/grep>, L<map|perlfunc/map>, L<join|perlfunc/join>, L<reverse|perlfunc/reverse>,
and L<sort|perlfunc/sort>, L<each|perlfunc/each>, 

=head4 vdelete
C<vdelete> deletes a specified value from the array.

  $a = 1->to(10);
  $a->vdelete(3);		# deletes 3

These non-standard extensions are also defined as methods on arrays:

=head4 uniq

C<uniq> removes all duplicate elements from an array and returns the new array 
with no duplicates.

   my @array = qw( 1 1 2 3 3 6 6 );
   @return = @array->uniq;	# \@return : 1 2 3 6

=head4 first
   
C<first> returns the first element of an array for which a callback returns true:

  $arr->first(sub { /5/ });

=head4 max

C<max> returns the maximum element of the array.
   
   $a = 1->to(10);
   $a->max; 			# 10
   
=head4 min

C<min> returns the minimum element of the array.

   $a = 1->to(10);
   $a->min; 			# 1
   
=head4 mean

C<mean> returns the mean of elements of an array.

   $a = 1->to(10);
   $a->mean;			# 55/10
   
=head4 var

C<var> returns the variance of the elements of an array.

   $a = 1->to(10);
   $a->var;			# 33/4

=head4 svar

C<svar> returns the standars variance.

  $a = 1->to(10);
  $a->svar;			# 55/6

=head4 at

C<at> returns the element at a specified index. This function does not modify the
original array.

   $a = 1->to(10);
   $a->at(2);			# 3
 
=head4 elems

C<elems> 

C<elems> returns the number of elements in an array.

   my @array = qw(foo bar baz);
   @array->elems;		# 3
   
=head4 length

C<length> returns the length of array.

   my @array = qw(foo bar baz);
   @array->length;		# 3

=head4 elements

C<elements> accesses the elements of an array.

   my @array = qw(foo bar baz);	
   my @returned = @array->elements;		#@array and @returned both are same  

=head4 size

Arrays can tell you how many elements they contain and the index of their last element:

  my $arr = [ 1 .. 10 ];
  print '$arr contains ', $arr->size,
        ' elements, the last having an index of ', $arr->last_index, "\n";

C<length>, C<size>, and C<elems> are synonyms for each other and return how many elements are in the array (as with C<scalar @array>).          

=head4 flatten

Array references have a C<flatten> method to dump their elements.
This is the same as C<< @{$array_ref} >>.

  my $arr = [ 1 .. 10 ];
  print join ' -- ', $arr->flatten, "\n";

Arrays can be iterated on using C<for> and C<foreach>. Both take a code
reference as the body of the for statement.

=head4 foreach
C<foreach> passes the current element itself in each pass.

=head4 for
C<for> passes the index of the current element in to that code block, and then
the current element, and then a reference to the array itself.

  my $arr = [ 1 .. 10 ];
  $arr->foreach(sub { print $_[0], "\n" });
  $arr->for(sub { die unless $_[1] == $_[2]->[$_[0]] });

=head4 sum

C<sum> is a toy poke at doing L<Language::Functional>-like stuff:

  print $arrref->sum, "\n";

=head4 count

C<count> returns the number of elements in array that are C<eq> to a specified value:

  my @array = qw/one two two three three three/;
  my $num = @array->count('three');  # returns 3

=head4 to, upto, downto

C<to>, C<upto>, and C<downto> create array references:

   1->to(5);      # creates [1, 2, 3, 4, 5]
   1->upto(5);    # creates [1, 2, 3, 4, 5]
   5->downto(5);  # creates [5, 4, 3, 2, 1]

Those wrap the C<..> operator.

C<Caveat>

While working with negative numbers we need to use () so as to avoid wrong 
evaluation.

  my $range = 10->to(1);	# this works
  my $range = -10->to(10);	# this doesn't work
  my $range = (-10)->to(10);	# this works

=head4 head

C<head> returns the first element from C<@list>.

    my $first = @list->head;

=head4 tail

C<tail> returns all but the first element from C<@list>. 
In scalar context returns an array reference.

    my @list = qw(foo bar baz quux);
    my @rest = @list->tail;  # [ 'bar', 'baz', 'quux' ]

Optionally, you can pass a number as argument to ask for the last C<$n>
elements:

    @rest = @list->tail(2); # [ 'baz', 'quux' ]

=head4 slice

C<slice> returns a list containing the elements from C<@list> at the indices
C<@indices>. In scalar context, returns an array reference.

    my @sublist = @list->slice(@indexes);

=head4 range

C<range> returns a list containing the elements from C<@list> with indices
ranging from C<$lower_idx> to C<$upper_idx>. It returns an array reference
in scalar context.

    my @sublist = @list->range( $lower_idx, $upper_idx );

=head4 last_index

C<last_index> corresponds to C<$#array> and is always one less than C<scalar @array>.
An array with one element in it has that one element in position zero (size of 1, last index of 0).
An array with zero elements in it has a size of C<-1>, as far as C<perl> is concerned (size of 0, last index of -1).

C<last_index> returns C<@array>'s last index (as with C<$#array>). 
Optionally, it takes a Coderef or a Regexp,
in which case it will return the index of the last element that matches
such regex or makes the code reference return true:

    my $last_index = @array->last_index

Or:

    my @things = qw(pear poll potato tomato);

    my $last_p = @things->last_index(qr/^p/); # 2

=head4 first_index

C<first_index>, for symmetry, returns the first index of C<@array>. If passed a Coderef
or Regexp, it will return the index of the first element that matches.

    my $first_index = @array->first_index; # 0

Or:

    my @things = qw(pear poll potato tomato);

    my $last_p = @things->first_index(qr/^t/); # 3


List context forces methods to return a list:

  my @arr = ( 1 .. 10 );
  print join ' -- ', @arr->grep(sub { $_ > 3 }), "\n";

Likewise, scalar context forces methods to return an array reference.

Methods may be chained; scalar context forces methods to return a reference:

  my @arr = ( 1 .. 10 );
  print @arr->grep(sub { $_ > 3 })->min, "\n";
  
  

=head3 Hash Methods

Hash methods work on both hashes and hash references.

The built in functions work as normal : 
L<delete|perlfunc/delete>, L<exists|perlfunc/exists>, L<keys|perlfunc/keys>,
L<values||perlfunc/values>, L<bless|perlfunc/bless>, L<tie|perlfunc/tie>,
L<tied|perlfunc/tied>, L<ref|perlfunc/ref>, L<undef|perlfunc/undef>,
are implemented.

C<at>, C<get>, C<put>, and C<set> appear to be hash getters and setters, fetching or
setting values for keys in hashes.

=head4 at

C<at> returns the value at a particular key.

   my $h = {a => 1, b => 2, c => 3};
   $h->at('b');			# 2

=head4 get

C<get> fetches the value at a key.
   
   my $h = {a => 1, b => 2, c => 3};
   $h->get('c');		# 3
   
=head4 put

C<put> inserts a key-value pair in the hash.

   my $h = {a => 1, b => 2, c => 3};
   $h->put('d' => 4, e=>5, f=>6);	#hash : (a => 1, b => 2, c => 3, d => 4, e=> 5, f => 6)
   
=head4 set

C<set> updates the value of a particular key in the hash. If the key does not
exist in the hash then insert the key-value in the hash.

  my $h = {a => 1, b => 2, c => 3};
  $h->set('a' => 8);			#hash : ( a => 8, b => 2, c => 3 )
  $h->set('e' => 9);			#hash : ( a => 8, b => 2, c => 3, e => 9)
  
=head4 lock_keys  

C<lock_keys> uses the method of the same name in L<Hash::Util>.  It forcibly resticts which
keys may exist in a hash to a specified set as a form of structure designed to guard against typos.

=head4 each

C<each> is like C<foreach> but for hash references. For each key in the hash,
the code reference is invoked with the key and the corresponding value as arguments:

  my $hashref = { foo => 10, bar => 20, baz => 30, quux => 40 };
  $hashref->each(sub { print $_[0], ' is ', $_[1], "\n" });

Or:

  my %hash = ( foo => 10, bar => 20, baz => 30, quux => 40 );
  %hash->each(sub { print $_[0], ' is ', $_[1], "\n" });

Unlike regular C<each>, this each will always iterate through the entire hash.

Hash keys appear in random order that varies from run to run (this is intentional,
to avoid calculated attacks designed to trigger algorithmic worst case scenario in C<perl>'s hash tables).
C<each> does not sort keys.  Instead, combine C<keys>, C<sort>, and C<foreach>:

   %hash->keys->sort->foreach(sub {
      print $_[0], ' is ', $hash{$_[0]}, "\n";
   });

=head4 slice

C<slice> takes a list of hash keys and returns the corresponding values e.g.

  my %hash = (
      one   => 'two',
      three => 'four',
      five  => 'six'
  );

  print %hash->slice(qw(one five))->join(' and '); # prints "two and six"

=head4 flip

C<flip> exchanges values for keys in a hash:

    my %things = ( foo => 1, bar => 2, baz => 5 );
    my %flipped = %things->flip; # { 1 => foo, 2 => bar, 5 => baz }

If there is more than one occurence of a certain value, any one of the
keys may end up as the value.  This is because of the random ordering
of hash keys.

    # Could be { 1 => foo }, { 1 => bar }, or { 1 => baz }
    { foo => 1, bar => 1, baz => 1 }->flip;

Because hash references cannot usefully be keys, it will not work on
nested hashes.

    { foo => [ 'bar', 'baz' ] }->flip; # dies

=head4 flatten

C<flatten> turns a single hash reference into a list of alternating keys and values.


=head3 Code Methods

L<bless|perlfunc/bless>, L<ref|perlfunc/ref>, 
C<map>, C<curry>, and C<times> are implemented for code references.

=head4 curry

You may C<curry> code references:

  $adding_up_numbers = sub {
      my $first_number = shift;
      my $second_number = shift;
      return $first_number + $second_number;
  };

  my $adding_five_to_numbers = $adding_up_numbers->curry(5);

  $adding_five_to_numbers->(20)->print; "\n"->print;
  
C<Caveat>

Due to Perl's precedence rules, some autoboxed literals may need to be parenthesized:
For instance, while this works:
  
  my $curried = sub { ... }->curry();

this doesn't:
  
  my $curried = \&foo->curry();

The solution is to wrap the reference in parentheses:
  my $curried = (\&foo)->curry();
  
=head4 times

C<times> executes a coderef a given number of times:

  5->times(sub { print "hi\n"});   # XXX likely to change but it's in the code so bloody doc it so I have incentive to rethink it

=head4 map

C<map> takes a list of things to run through a code block, and returns an array reference or list depending on context:

  sub { my $t = $_[0]; $t =~ tr/a-z/zyxwvutsrqponmlkjihgfedcba/; $t }->map(
    "Black", "crow", "flies", "at", "midnight"
  )->say;


=head2 What's Missing?

File and socket operations are already implemented in an object-oriented fashion
care of L<IO::Handle>, L<IO::Socket::INET>, and L<IO::Any>.

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


=head2 Autoboxing

I<This section quotes four pages from the manuscript of Perl 6 Now: The Core Ideas Illustrated with Perl 5 by Scott Walters. The text appears in the book starting at page 248. This copy lacks the benefit of copyedit - the finished product is of higher quality.>

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
coerces C<%hash> and C<@array> into references, suitable for use with F<autobox>.
(Note that F<autobox> also does this automatically as of version 2.40.)
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
The C<map()> method defined in the C<autobox::Core::CODE> package takes for its arguments the things
to map.
The C<map()> method defined in the C<autobox::Core::ARRAY> package takes for its argument a code reference
to apply to each element of the array.

I<Here ends the text quoted from the Perl 6 Now manuscript.>


=head1 BUGS

Yes. Report them to the author, L<scott@slowass.net>, or post them to GitHub's bug tracker
at L<https://github.com/scrottie/autobox-Core/issues>.

The API is not yet stable -- Perl 6-ish things and local extensions are still being renamed.


=head1 HISTORY

See the Changes file.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009, 2010, 2011 by Scott Walters and various contributors listed (and unlisted) below.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.9 or,
at your option, any later version of Perl 5 you may have available.

This library is distributed in the hope that it will be useful, but without
any warranty; without even the implied warranty of merchantability or fitness
for a particular purpose.


=head1 SEE ALSO

=over 1

=item L<autobox>

=item L<Moose::Autobox>

=item L<Perl6::Contexts>

=item L<http://github.com/gitpan/autobox-Core>

=item L<IO::Any>

=item Perl 6: L<< http://dev.perl.org/perl6/apocalypse/ >>.

=back


=head1 AUTHORS

Scott Walters, L<scott@slowass.net>.

Michael Schwern and the L<perl5i> contributors for tests, code, and feedback.

JJ contributed a C<strip> method for scalars - thanks JJ!

Ricardo SIGNES contributed patches.

Thanks to Matt Spear, who contributed tests and definitions for numeric operations.

Mitchell N Charity reported a bug and sent a fix.

Thanks to chocolateboy for L<autobox> and for the encouragement.

Thanks to Bruno Vecchi for bug fixes and many, many new tests going into version 0.8.

Thanks to L<http://github.com/daxim> daxim/Lars DIECKOW pushing in fixes and patches from the RT queue
along with fixes to build and additional doc examples.

=cut

#
# SCALAR
#

package autobox::Core::SCALAR;

#       Functions for SCALARs or strings
#          "chomp", "chop", "chr", "crypt", "hex", "index", "lc",
#           "lcfirst", "length", "oct", "ord", "pack",
#           "q/STRING/", "qq/STRING/", "reverse", "rindex",
#           "sprintf", "substr", "tr///", "uc", "ucfirst", "y///"

# current doesn't handle scalar references - get can't call method chomp on unblessed reference etc when i try to support it

sub chomp      { CORE::chomp($_[0]); }
sub chop       { CORE::chop($_[0]); }
sub chr        { CORE::chr($_[0]); }
sub crypt      { CORE::crypt($_[0], $_[1]); }
sub index      { $_[2] ? CORE::index($_[0], $_[1], $_[2]) : CORE::index($_[0], $_[1]); }
sub lc         { CORE::lc($_[0]); }
sub lcfirst    { CORE::lcfirst($_[0]); }
sub length     { CORE::length($_[0]); }
sub ord        { CORE::ord($_[0]); }
sub pack       { CORE::pack(shift, @_); }
sub reverse    {
    # Always reverse scalars as strings, never as a single element list.
    return scalar CORE::reverse($_[0]);
}

sub rindex {
    return CORE::rindex($_[0], $_[1]) if @_ == 2;
    return CORE::rindex($_[0], $_[1], @_[2.. $#_]);
}

sub sprintf { CORE::sprintf($_[0], $_[1], @_[2.. $#_]); }

sub substr {
    return CORE::substr($_[0], $_[1]) if @_ == 2;
    return CORE::substr($_[0], $_[1], @_[2 .. $#_]);
}

sub uc         { CORE::uc($_[0]); }
sub ucfirst    { CORE::ucfirst($_[0]); }
sub unpack     { CORE::unpack($_[0], @_[1..$#_]); }
sub quotemeta  { CORE::quotemeta($_[0]); }
sub vec        { CORE::vec($_[0], $_[1], $_[2]); }
sub undef      { $_[0] = undef }
sub defined    { CORE::defined($_[0]) }
sub m          { [ $_[0] =~ m{$_[1]} ] }
sub nm         { [ $_[0] !~ m{$_[1]} ] }
sub s          { $_[0] =~ s{$_[1]}{$_[2]} }
sub split      { wantarray ? split $_[1], $_[0] : [ split $_[1], $_[0] ] }

sub eval       { CORE::eval "$_[0]"; }
sub system     { CORE::system @_; }
sub backtick   { `$_[0]`; }

#       Numeric functions
#           "abs", "atan2", "cos", "exp", "hex", "int", "log",
#           "oct", "rand", "sin", "sqrt", "srand"

sub abs       { CORE::abs($_[0]) }
sub atan2     { CORE::atan2($_[0], $_[1]) }
sub cos       { CORE::cos($_[0]) }
sub exp       { CORE::exp($_[0]) }
sub int       { CORE::int($_[0]) }
sub log       { CORE::log($_[0]) }
sub oct       { CORE::oct($_[0]) }
sub hex       { CORE::hex($_[0]); }
sub rand      { CORE::rand($_[0]) }
sub sin       { CORE::sin($_[0]) }
sub sqrt      { CORE::sqrt($_[0]) }

# functions for array creation
sub to {
    my $res = $_[0] < $_[1] ? [$_[0]..$_[1]] : [CORE::reverse $_[1]..$_[0]];
    return wantarray ? @$res : $res
}
sub upto {
    return wantarray ? ($_[0]..$_[1]) : [ $_[0]..$_[1] ]
}
sub downto  {
    my $res = [ CORE::reverse $_[1]..$_[0] ];
    return wantarray ? @$res : $res
}

# Lars D didn't explain the intention of this code either in a comment or in docs and I don't see the point
#sub times {
#   if ($_[1]) {
#     for (0..$_[0]-1) { $_[1]->($_); }; $_[0];
#   } else {
#       0..$_[0]-1
#   }
#}

# doesn't minipulate scalars but works on scalars

sub print { CORE::print @_; }
sub say   { CORE::print @_, "\n"}

# operators that work on scalars:

sub concat { CORE::join '', @_; }
sub strip  {
    my $s = CORE::shift;
    $s =~ s/^\s+//; $s =~ s/\s+$//;
    return $s;
}

# operator schizzle
sub add  { $_[0] + $_[1]; }
sub and  { $_[0] && $_[1]; }
sub band { $_[0] & $_[1]; }
sub bor  { $_[0] | $_[1]; }
sub bxor { $_[0] ^ $_[1]; }
sub cmp  { $_[0] cmp $_[1]; }
sub dec  { my $t = CORE::shift @_; --$t; }
sub div  { $_[0] / $_[1]; }
sub eq   { $_[0] eq $_[1]; }
sub flip { ~$_[0]; }
sub ge   { $_[0] ge $_[1]; }
sub gt   { $_[0] gt $_[1]; }
sub inc  { my $t = CORE::shift @_; ++$t; }
sub le   { $_[0] le $_[1]; }
sub lshift { $_[0] << $_[1]; }
sub lt   { $_[0] lt $_[1]; }
sub mod  { $_[0] % $_[1]; }
sub mult { $_[0] * $_[1]; }
sub mcmp { $_[0] <=> $_[1]; }
sub ne   { $_[0] ne $_[1]; }
sub neg  { -$_[0]; }
sub meq  { $_[0] == $_[1]; }
sub mge  { $_[0] >= $_[1]; }
sub mgt  { $_[0] > $_[1]; }
sub mle  { $_[0] <= $_[1]; }
sub mlt  { $_[0] < $_[1]; }
sub mne  { $_[0] != $_[1]; }
sub not  { !$_[0]; }
sub or   { $_[0] || $_[1]; }
sub pow  { $_[0] ** $_[1]; }
sub rpt  { $_[0] x $_[1]; }
sub rshift { $_[0] >> $_[1]; }
sub sub  { $_[0] - $_[1]; }
sub xor  { $_[0] ^ $_[1]; }

# sub bless (\%$)   { CORE::bless $_[0], $_[1] } # HASH, ARRAY, CODE already have a bless() and blessing a non-reference works (autobox finds the reference in the pad or stash!).  "can't bless a non-referenc value" for non-reference lexical and package scalars.  this would work for (\$foo)->bless but then, unlike arrays, we couldn't find the reference to the variable again later so there's not much point I can see.

# from perl5i:


sub title_case {
    my ($string) = @_;
    $string =~ s/\b(\w)/\U$1/g;
    return $string;
}


sub center {
    my ($string, $size, $char) = @_;
    Carp::carp("Use of uninitialized value for size in center()") if !defined $size;
    $size = defined($size) ? $size : 0;
    $char = defined($char) ? $char : ' ';

    if (CORE::length $char > 1) {
        my $bad = $char;
        $char = CORE::substr $char, 0, 1;
        Carp::carp("'$bad' is longer than one character, using '$char' instead");
    }

    my $len             = CORE::length $string;

    return $string if $size <= $len;

    my $padlen          = $size - $len;

    # pad right with half the remaining characters
    my $rpad            = CORE::int( $padlen / 2 );

    # bias the left padding to one more space, if $size - $len is odd
    my $lpad            = $padlen - $rpad;

    return $char x $lpad . $string . $char x $rpad;
}

sub ltrim {
    my ($string,$trim_charset) = @_;
    $trim_charset = '\s' unless defined $trim_charset;
    my $re = qr/^[$trim_charset]*/;
    $string =~ s/$re//;
    return $string;
}


sub rtrim {
    my ($string,$trim_charset) = @_;
    $trim_charset = '\s' unless defined $trim_charset;
    my $re = qr/[$trim_charset]*$/;
    $string =~ s/$re//;
    return $string;
}


sub trim {
    my $charset = $_[1];

    return rtrim(ltrim($_[0], $charset), $charset);
}

# POSIX is huge
#require POSIX;
#*ceil  = \&POSIX::ceil;
#*floor = \&POSIX::floor;
#*round_up   = \&ceil;
#*round_down = \&floor;
#sub round {
#    abs($_[0] - int($_[0])) < 0.5 ? round_down($_[0])
#                                  : round_up($_[0])
#}

require Scalar::Util;
*is_number = \&Scalar::Util::looks_like_number;
sub is_positive         { Scalar::Util::looks_like_number($_[0]) && $_[0] > 0 }
sub is_negative         { Scalar::Util::looks_like_number($_[0]) && $_[0] < 0 }
sub is_integer          { Scalar::Util::looks_like_number($_[0]) && ((CORE::int($_[0]) - $_[0]) == 0) }
*is_int = \&is_integer;
sub is_decimal          { Scalar::Util::looks_like_number($_[0]) && ((CORE::int($_[0]) - $_[0]) != 0) }


##########################################################

#
# HASH
#

package autobox::Core::HASH;

use Carp 'croak';

#       Functions for real %HASHes
#           "delete", "each", "exists", "keys", "values"

sub delete  {
    my $hash = CORE::shift;

    my @res = ();
    foreach(@_) {
        push @res, CORE::delete $hash->{$_};
    }

    return wantarray ? @res : \@res
}

sub exists {
    my $hash = CORE::shift;
    return CORE::exists $hash->{$_[0]};
}

sub keys {
    return wantarray ? CORE::keys %{$_[0]} : [ CORE::keys %{$_[0]} ];
}

sub values {
    return wantarray ? CORE::values %{$_[0]} : [ CORE::values %{$_[0]} ]
}

# local extensions

sub get { my @res = $_[0]->{@_[1..$#_]}; return wantarray ? @res : \@res }
*at = *get;

sub put {
    my $h = CORE::shift @_;
    my %h = @_;

    while(my ($k, $v) = CORE::each %h) {
        $h->{$k} = $v;
    };

    return $h;
}

sub set {
    my $h = CORE::shift @_;
    my %h = @_;
    while(my ($k, $v) = CORE::each %h) {
        $h->{$k} = $v;
    };

    return $h;
}

sub flatten { %{$_[0]} }

sub each {
    my $hash = CORE::shift;
    my $cb = CORE::shift;

    # Reset the each iterator. (This is efficient in void context)
    CORE::keys %$hash;

    while((my $k, my $v) = CORE::each(%$hash)) {
        # local $_ = $v; # XXX may I break stuff?
        $cb->($k, $v);
    }

    return;
}

#       Keywords related to classes and object-orientedness
#           "bless", "dbmclose", "dbmopen", "package", "ref",
#           "tie", "tied", "untie", "use"

sub bless  { CORE::bless $_[0], $_[1] }
sub tie    { CORE::tie   $_[0], @_[1 .. $#_] }
sub tied   { CORE::tied  $_[0] }
sub ref    { CORE::ref   $_[0] }

sub undef  { $_[0] = {} }

sub slice {
    my ($h, @keys) = @_;
    wantarray ? @{$h}{@keys} : [ @{$h}{@keys} ];
}

# okey, ::Util stuff should be core

use Hash::Util;

sub lock_keys { Hash::Util::lock_keys(%{$_[0]}); $_[0]; }

# from perl5i

sub flip {
    croak "Can't flip hash with references as values"
        if grep { CORE::ref } CORE::values %{$_[0]};

    return wantarray ? reverse %{$_[0]} : { reverse %{$_[0]} };
}

#
# ARRAY
#
##############################################################################################
package autobox::Core::ARRAY;

use constant FIVETEN => ($] >= 5.010);

use Carp 'croak';

#       Functions for list data
#           "grep", "join", "map", "qw/STRING/", "reverse",
#           "sort", "unpack"

# at one moment, perl5i had this in it:

#sub grep {
#    my ( $array, $filter ) = @_;
#    my @result = CORE::grep { $_ ~~ $filter } @$array;
#    return wantarray ? @result : \@result;
#}

sub grep {
    no warnings 'redefine';
    if(FIVETEN) {
         eval '
             # protect perl 5.8 from the alien, futuristic syntax of 5.10
             *grep = sub {
                 my $arr = CORE::shift;
                 my $filter = CORE::shift;
                 my @result = CORE::grep { $_ ~~ $filter } @$arr;
                 return wantarray ? @result : \@result;
             }
        ' or croak $@;
    } else {
        *grep = sub {
             my $arr = CORE::shift;
             my $filter = CORE::shift;
             my @result;
             if( CORE::ref $filter eq 'Regexp' ) {
                 @result = CORE::grep { m/$filter/ } @$arr;
             } elsif( ! ref $filter ) {
                 @result = CORE::grep { $filter eq $_ } @$arr;  # find all of the exact matches
             } else {
                 @result = CORE::grep { $filter->($_) } @$arr;
             }
             return wantarray ? @result : \@result;
        };
    }
    autobox::Core::ARRAY::grep(@_);
}

# last version: sub map (\@&) { my $arr = CORE::shift; my $sub = shift; [ CORE::map { $sub->($_) } @$arr ]; }

sub map {
    my( $array, $code ) = @_;
    my @result = CORE::map { $code->($_) } @$array;
    return wantarray ? @result : \@result;
}

sub join { my $arr = CORE::shift; my $sep = CORE::shift; CORE::join $sep, @$arr; }

sub reverse { my @res = CORE::reverse @{$_[0]}; wantarray ? @res : \@res; }

sub sort {
    my $arr = CORE::shift;
    my $sub = CORE::shift() || sub { $a cmp $b };
    my @res = CORE::sort { $sub->($a, $b) } @$arr;
    return wantarray ? @res : \@res;
}

# functionalish stuff

sub sum { my $arr = CORE::shift; my $res = 0; $res += $_ foreach(@$arr); $res; }

sub mean { my $arr = CORE::shift; my $res = 0; $res += $_ foreach(@$arr); $res/@$arr; }

sub var {
    my $arr = CORE::shift;
    my $mean = 0;
    $mean += $_ foreach(@$arr);
    $mean /= @$arr;
    my $res = 0;
    $res += ($_-$mean)**2 foreach (@$arr);
    $res/@$arr;
}

sub svar {
    my $arr = CORE::shift;
    my $mean = 0;
    $mean += $_ foreach(@$arr);
    $mean /= @$arr;
    my $res = 0;
    $res += ($_-$mean)**2 foreach (@$arr);
    $res/(@$arr-1);
}

sub max {
    my $arr = CORE::shift;
    my $max = $arr->[0];
    foreach (@$arr) {
        $max = $_ if $_ > $max
    }

    return $max;
}

sub min {
    my $arr = CORE::shift;
    my $min = $arr->[0];
    foreach (@$arr) {
        $min = $_ if $_ < $min
    }

    return $min;
}

# Functions for real @ARRAYs
#    "pop", "push", "shift", "splice", "unshift"

sub pop  { CORE::pop @{$_[0]}; }

sub push {
    my $arr = CORE::shift;
    CORE::push @$arr, @_;
    return wantarray ? return @$arr : $arr;
}

sub unshift {
    my $a = CORE::shift;
    CORE::unshift(@$a, @_);
    return wantarray ? @$a : $a;
}

sub delete  {
    my $arr = CORE::shift;
    CORE::delete $arr->[$_[0]];
    return wantarray ? @$arr : $arr
}

sub vdelete {
    my $arr = CORE::shift;
    @$arr = CORE::grep {$_ ne $_[0]} @$arr;
    return wantarray ? @$arr : $arr
}

sub shift   {
    my $arr = CORE::shift;
    return CORE::shift @$arr;
}

sub undef   { $_[0] = [] }

# doesn't modify array

sub exists {
    my $arr = CORE::shift;
    return CORE::scalar( CORE::grep {$_ eq $_[0]} @$arr ) > 0;
}

sub at {
    my $arr = CORE::shift;
    return $arr->[$_[0]];
}

sub count {
    my $arr = CORE::shift;
    return CORE::scalar(CORE::grep {$_ eq $_[0]} @$arr);
}

sub uniq {
    my $arr = CORE::shift;

    # shamelessly from List::MoreUtils
    my %uniq;
    my @res = CORE::map { $uniq{$_}++ == 0 ? $_ : () } @$arr;

    return wantarray ? @res : \@res;
}

# tied and blessed

sub bless  { CORE::bless $_[0], $_[1] }
sub tie    { CORE::tie   $_[0], @_[1 .. $#_] }
sub tied   { CORE::tied  $_[0] }
sub ref    { CORE::ref   $_[0] }

# perl 6-ish extensions to Perl 5 core stuff

# sub first(\@) { my $arr = CORE::shift; $arr->[0]; } # old, incompat version

sub first {
    # from perl5i, modified
    # XXX needs test.  take from perl5i?
    no warnings "redefine";
    if(FIVETEN) {
         eval '
             # protect perl 5.8 from the alien, futuristic syntax of 5.10
             *first = sub {
                 my ( $array, $filter ) = @_;
                 # Deep recursion and segfault (lines 90 and 91 in first.t) if we use
                 # the same elegant approach as in grep().
                 if ( @_ == 1 ) {
                     return $array->[0];
                 } elsif ( CORE::ref $filter eq "Regexp" ) {
                     return List::Util::first( sub { $_ ~~ $filter }, @$array );
                 } else {
                     return List::Util::first( sub { $filter->() }, @$array );
                 }
             };
        ' or croak $@;
    } else {
        *first = sub {
            my ( $array, $filter ) = @_;
            if ( @_ == 1 ) {
                return $array->[0];
            } elsif ( CORE::ref $filter eq "Regexp" ) {
                return List::Util::first( sub { $_ =~ m/$filter/ }, @$array );
            } else {
                return List::Util::first( sub { $filter->() }, @$array );
            }
        };
    }
    autobox::Core::ARRAY::first(@_);
}

sub size   { my $arr = CORE::shift; CORE::scalar @$arr; }
sub elems  { my $arr = CORE::shift; CORE::scalar @$arr; } # Larry announced it would be elems, not size
sub length { my $arr = CORE::shift; CORE::scalar @$arr; }

# misc

sub each {
    # same as foreach(), apo12 mentions this
    # XXX should we try to build a result list if we're in non-void context?
    my $arr = CORE::shift; my $sub = CORE::shift;
    foreach my $i (@$arr) {
        # local $_ = $i; # XXX may I break stuff?
        $sub->($i);
    }
}

sub foreach {
    my $arr = CORE::shift; my $sub = CORE::shift;
    foreach my $i (@$arr) {
        # local $_ = $i; # XXX may I break stuff?
        $sub->($i);
    }
}

sub for {
    my $arr = CORE::shift; my $sub = CORE::shift;
    for(my $i = 0; $i <= $#$arr; $i++) {
        # local $_ = $arr->[$i]; # XXX may I break stuff?
        $sub->($i, $arr->[$i], $arr);
    }
}

sub print { my $arr = CORE::shift; my @arr = @$arr; CORE::print "@arr"; }
sub say   { my $arr = CORE::shift; my @arr = @$arr; CORE::print "@arr\n"; }

# local

sub elements { ( @{$_[0]} ) }
sub flatten  { ( @{$_[0]} ) }

sub head {
    return $_[0]->[0];
}

sub slice {
    my $list = CORE::shift;
    # the rest of the arguments in @_ are the indices to take

    return wantarray ? @$list[@_] : [@{$list}[@_]];
}

sub range {
    my ($array, $lower, $upper) = @_;

    my @slice = @{$array}[$lower .. $upper];

    return wantarray ? @slice : \@slice;

}

sub tail {
    my $last = $#{$_[0]};

    my $first = defined $_[1] ? $last - $_[1] + 1 : 1;

    Carp::croak("Not enough elements in array") if $first < 0;

    # Yeah... avert your eyes
    return wantarray ? @{$_[0]}[$first .. $last] : [@{$_[0]}[$first .. $last]];
}

sub first_index {
    if (@_ == 1) {
        return 0;
    }
    else {
        my ($array, $arg) = @_;

        my $filter = CORE::ref($arg) eq 'Regexp' ? sub { $_[0] =~ $arg } : $arg;

        foreach my $i (0 .. $#$array) {
            return $i if $filter->($array->[$i]);
        }

        return
    }
}

sub last_index {
    if (@_ == 1) {
        return $#{$_[0]};
    }
    else {
        my ($array, $arg) = @_;

        my $filter = CORE::ref($arg) eq 'Regexp' ? sub { $_[0] =~ $arg } : $arg;

        foreach my $i (CORE::reverse 0 .. $#$array ) {
            return $i if $filter->($array->[$i]);
        }

        return
    }
}

##############################################################################################

#
# CODE
#

package autobox::Core::CODE;

sub bless    { CORE::bless $_[0], $_[1] }
sub ref      { CORE::ref   $_[0] }

# perl 6-isms

sub curry  { my $code = CORE::shift; my @args = @_; sub { CORE::unshift @_, @args; goto &$code; }; }

# local - polymorphic

sub map  { my $code = CORE::shift; my @res = CORE::map { $code->($_) } @_; wantarray ? @res : \@res; }

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

