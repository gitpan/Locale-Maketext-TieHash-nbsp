package Locale::Maketext::TieHash::nbsp; ## no critic (Capitalization)

use strict;
use warnings;

our $VERSION = '1.02';

use parent qw(Tie::Sub);

use Params::Validate qw(:all);

my $get_substitute_sub = sub {
    my $separator = shift || '&nbsp;';

    return sub {
        (my $string = shift) =~ s{ }{$separator}msg;
        return $string;
    };
};

## no critic (ArgUnpacking)

sub TIEHASH {
    my ($class, %init) = validate_pos(
        @_,
        {type => SCALAR},
        ( ({type => SCALAR}, 1) x ((@_ - 1) / 2) ),
    );

    my $self = $class->SUPER::TIEHASH( $get_substitute_sub->() );
    $self->config(%init);

    return $self;
}

sub config {
    return shift->SUPER::config(@_) if caller eq 'Tie::Sub';
    # object, hash
    my ($self, %init) = validate_pos(
        @_,
        {isa => __PACKAGE__},
        ( ({type => SCALAR}, 1) x ((@_ - 1) / 2) ),
    );
    validate_with(
        params => \%init,
        spec   => {
            sub       => {
                type      => CODEREF,
                optional  => 1,
                callbacks => {
                    separator_not_exists => sub {
                        return ! defined $init{separator};
                    },
                },
            },
            separator => {
                type      => SCALAR,
                optional  => 1,
                callbacks => {
                    sub_not_exists => sub {
                        return ! defined $init{sub};
                    },
                },
            },
        },
        called => 'the config hash',
    );

    if (exists $init{sub}) {
        return $self->SUPER::config( $init{sub} );
    }
    if (exists $init{separator}) {
        return $self->SUPER::config(
            $get_substitute_sub->( $init{separator} )
        );
    }

    return;
}

# $Id$

1;

__END__

=pod

=head1 NAME

Locale::Maketext::TieHash::nbsp - Tying subroutine to a hash

=head1 VERSION

1.02

=head1 SYNOPSIS

    use strict;
    use warnings;

    use Locale::Maketext::TieHash::nbsp;

=head2 without a special configuration (using entities)

    tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';
    print $nbsp{'15 pieces'};
    # result: '15&nbsp;pieces'

=head2 configuration of unicode separator string

    use charnames qw(:full);

    tie my %nbsp, 'Locale::Maketext::TieHash::nbsp', separator => "\N{NO-BREAK SPACE}";
    print $nbsp{'15 pieces'};
    # result is eq "15\N{NO-BREAK SPACE}pieces"

=head2 configuration of visible string

To test the script, store an visible string.

    tie my %nbsp, 'Locale::Maketext::TieHash::nbsp', separator => q{~};
    print $nbsp{'15 pieces'};
    # result: '15~pieces'

=head2 configuration using a subroutine

    tie my %nbsp, 'Locale::Maketext::TieHash::nbsp', sub => sub {
        (my $string = shift) =~ s{ }{*}msg;
        return $string;
    };
    print $nbsp{'15 pieces'};
    # result: '15*pieces'

=head2 write/read configuration

    my $former_code_ref = tied(%nbsp)->config(separator => $separator);

or

    my $former_code_ref = tied(%nbsp)->config(sub => $new_code_ref);

=head1 EXAMPLE

Inside of this Distribution is a directory named example.
Run this *.pl files.

=head1 DESCRIPTION

Subroutines don't have interpreted into strings.
The module ties a subroutine to a hash.
The Subroutine is executed at fetch hash.
At long last this is the same, only the notation is shorter.

Sometimes the subroutine 'sub' expects more than 1 parameter.
Then submit a reference on an array as hash key.

=head1 SUBROUTINES/METHODS

=head2 method TIEHASH

    tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';

'TIEHASH' ties your hash and set the options defaults.

=head2 method config

Stores the seperator string or a subroutine.

    tied(%nbsp)->config(
        sub => sub {
            (my $string = shift) =~ s{ }{&nbsp;}msg;
            return $string;
        },
    );

or

    tied(%nbsp)->config(
        separator => '&nbsp;',
    );

'config' accepts all parameters as Hash
and gives a Hash back with all set attributes.

=head2 method FETCH

Give your string as key of your hash.
'FETCH' will substitute the whitespace to '&nbsp;' and give it back as value.

    # Substitute
    print $nbsp{$string};

=head1 DIAGNOSTICS

All methods can croak at false parameters.

=head1 CONFIGURATION AND ENVIRONMENT

nothing

=head1 DEPENDENCIES

parent

L<Tie::Sub>

L<Params::Validate> Comfortable parameter validation

=head1 INCOMPATIBILITIES

not known

=head1 BUGS AND LIMITATIONS

not known

=head1 SEE ALSO

L<Locale::Maketext> Localisation framework

L<Tie::Hash>

=head1 AUTHOR

Steffen Winkler

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2004 - 2009,
Steffen Winkler
C<< <steffenw at cpan.org> >>.
All rights reserved.

This module is free software;
you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut