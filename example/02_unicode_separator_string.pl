#!perl

use strict;
use warnings;

our $VERSION = 0;

use Carp qw(croak);
use English qw(-no_match_vars $OS_ERROR);
use Locale::Maketext::TieHash::nbsp;
use charnames qw(:full);
use utf8;

binmode STDOUT, 'encoding(UTF-8)'
    or croak $OS_ERROR;

tie my %nbsp, 'Locale::Maketext::TieHash::nbsp', separator => "\N{NO-BREAK SPACE}"; ## no critic (Ties)
() = print $nbsp{'15 pieces'};

# result is eq "15\N{NO-BREAK SPACE}pieces"

# $Id$