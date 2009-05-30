use strict;
use warnings;

use Test::More tests => 11 + 1;
use Test::NoWarnings;
use Test::Exception;

BEGIN { use_ok('Locale::Maketext::TieHash::nbsp') };

my $object = tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';
isa_ok(
    $object,
    'Locale::Maketext::TieHash::nbsp',
);
is(
    $nbsp{'1 2 3'},
    '1&nbsp;2&nbsp;3',
    'check transformation',
);

{
    my $sub = sub {
        my ($p1, $p2) = @_;

        return "$p1, $p2";
    };
    $object->config(sub => $sub);
    is(
        $nbsp{[1,2]},
        '1, 2',
        'check substituted subroutine',
    );
    is(
        $object->config(sub => sub {}),
        $sub,
        'save and get back subroutine, use method "config"',
    );
}

$object->config(separator => '-');
is(
    $nbsp{'1 2 3'},
    '1-2-3',
    'check changed separator',
);

throws_ok(
    sub {
        $object->config(undef() => undef);
    },
    qr{'undef'}xms,
    'initiating dying by configuring undefined key',
);

throws_ok(
    sub {
        $object->config(wrong => undef);
    },
    qr{\b wrong \b}xms,
    'initiating dying by configuring wrong key',
);

throws_ok(
    sub {
        $object->config(sub => []);
    },
    qr{'arrayref'}xms,
    'initiating dying by configuring wrong reference',
);

throws_ok(
    sub {
        $nbsp{sub} = undef;
    },
    qr{\QCan't locate object method "STORE"\E}xms,
    'STORE is not implemented',
);

throws_ok(
    sub {
        $object->config(
            separator => q{},
            sub       => sub {},
        );
    },
    qr{x}xms,
    'failed config both ways',
);