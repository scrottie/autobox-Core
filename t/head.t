#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use autobox::Core;

my @array = qw(foo bar baz);

ok @array->head;
is @array->head, 'foo';
