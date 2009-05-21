use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name       => 'Locale::Maketext::TieHash::nbsp',
    license           => 'perl',
    dist_author       => 'Steffen Winkler <steffenw@cpan.org>',
    dist_version_from => 'lib/Locale/Maketext/TieHash/nbsp.pm',
    requires          => {
        parent             => 0,
        'Tie::Sub'         => '0.07',
        'Params::Validate' => 0,
    },
    build_requires => {
        'Test::More'       => 0,
        'Test::NoWarnings' => 0,
        'Test::Exception'   => 0,
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