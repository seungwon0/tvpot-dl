#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::TvpotDl' ) || print "Bail out!
";
}

diag( "Testing App::TvpotDl $App::TvpotDl::VERSION, Perl $], $^X" );
