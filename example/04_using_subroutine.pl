#!perl

use strict;
use warnings;

our $VERSION = 0;

use Locale::Maketext::TieHash::nbsp;

tie my %nbsp, 'Locale::Maketext::TieHash::nbsp', sub => sub { ## no critic (Ties)
    (my $string = shift) =~ s{ }{*}msg;
    return $string;
};
() = print $nbsp{'15 pieces'};

# result: '15*pieces'

# $Id$