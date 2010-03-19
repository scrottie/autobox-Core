use Test::More qw(no_plan);
use strict;
use warnings;
use autobox::Core;

is 'so (many [pairs])'->quotemeta, 'so\ \(many\ \[pairs\]\)';
