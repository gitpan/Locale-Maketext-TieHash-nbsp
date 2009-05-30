use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name       => 'Locale::Maketext::TieHash::nbsp',
    license           => 'perl',
    dist_author       => 'Steffen Winkler <steffenw at cpan.org>',
    dist_version_from => 'lib/Locale/Maketext/TieHash/nbsp.pm',
    requires          => {
        perl               => 5.006001,
        parent             => 0,
        'Tie::Sub'         => '0.07',
        'Params::Validate' => 0,
    },
    build_requires => {
        # Cwd              => 0, # perl dist
        'Test::Simple'     => 0, # for Test::More
        'Test::NoWarnings' => 0,
        'Test::Exception'  => 0,
    },
    recommends => {
        # build
        'Test::Pod'           => '1.14',
        'Test::Pod::Coverage' => '1.04',
        'Test::More'          => 0,
    },
    create_makefile_pl   => 'traditional',
    recursive_test_files => 1,
    add_to_cleanup       => [ qw(
        META.yml *.bak *.gz Makefile.PL
    ) ],
)->create_build_script();