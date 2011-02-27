use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'App::TvpotDl',
    license           => 'perl',
    dist_author       => q{Seungwon Jeong <seungwon0@gmail.com>},
    dist_version_from => 'lib/App/TvpotDl.pm',
    requires          => {
        'perl'         => '5.10.0',
        'strict'       => 0,
        'warnings'     => 0,
        'autodie'      => 0,
        'English'      => 0,
        'LWP::Simple'  => 0,
        'Carp'         => 0,
        'Getopt::Long' => 0,
    },
    build_requires     => { 'Test::More' => 0, },
    script_files       => [ 'bin/tvpot-dl', ],
    add_to_cleanup     => [ 'tvpot-dl-*', ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
