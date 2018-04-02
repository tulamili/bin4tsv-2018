#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CLI::ComputerFiles::Util' ) || print "Bail out!\n";
}

diag( "Testing CLI::ComputerFiles::Util $CLI::ComputerFiles::Util::VERSION, Perl $], $^X" );
