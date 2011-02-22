use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::TvpotDl',
    license             => 'perl',
    dist_author         => q{Seungwon Jeong <seungwon0@gmail.com>},
    dist_version_from   => 'lib/App/TvpotDl.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'tvpot-dl-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
