use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME		=> 'autobox::Core',
    VERSION_FROM	=> 'Core.pm', # finds $VERSION
    PREREQ_PM		=> { 'autobox' => 0.11 }, 
    ABSTRACT_FROM       => 'Core.pm', # retrieve abstract from module
    AUTHOR              => 'Scott Walters scott@slowass.net',
);
