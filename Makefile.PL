use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::TvpotDl',
    AUTHOR              => q{Seungwon Jeong <seungwon0@gmail.com>},
    VERSION_FROM        => 'lib/App/TvpotDl.pm',
    ABSTRACT_FROM       => 'lib/App/TvpotDl.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES           => [ 'bin/tvpot-dl' ],
    PREREQ_PM => {
        'Test::More'  => 0,
        'autodie'     => 0,
        'English'     => 0,
        'LWP::Simple' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'tvpot-dl-*' },
);
