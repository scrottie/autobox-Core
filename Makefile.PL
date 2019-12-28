use strict;
use warnings;

use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME               => 'autobox::Core',
    VERSION_FROM       => 'lib/autobox/Core.pm',               # finds $VERSION
    PREREQ_PM          => {
        autobox => 2.86,
        'Test::More' => 0.88,
        Want   => 0.29,
    },
    ABSTRACT_FROM      => 'lib/autobox/Core.pm',               # retrieve abstract from module
    AUTHOR             => 'Scott Walters scott@slowass.net',
    (eval($ExtUtils::MakeMaker::VERSION) >= 6.31 ? (LICENSE => 'perl') : ()),
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.48',                       # for META_MERGE and MIN_PERL_VERSION
    },
    META_MERGE => {
        resources => {
            bugtracker => 'http://github.com/scrottie/autobox-Core/issues',
            repository => 'http://github.com/scrottie/autobox-Core',
        }
    },
    MIN_PERL_VERSION => 5.008,
);
