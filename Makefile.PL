use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME               => 'autobox::Core',
    VERSION_FROM       => 'lib/autobox/Core.pm',               # finds $VERSION
    PREREQ_PM          => {'autobox' => 0.11},
    ABSTRACT_FROM      => 'lib/autobox/Core.pm',               # retrieve abstract from module
    AUTHOR             => 'Scott Walters scott@slowass.net',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.46',                       # for META_MERGE
    },
    META_MERGE => {
        resources => {
            bugtracker => 'http://github.com/scrottie/autobox-Core/issues',
            repository => 'http://github.com/scrottie/autobox-Core',
        }
    },
);
