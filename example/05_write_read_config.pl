#!perl

use strict;
use warnings;

our $VERSION = 0;

use Locale::Maketext::TieHash::nbsp;

tie my %nbsp, 'Locale::Maketext::TieHash::nbsp'; ## no critic (Ties)

() = print join "\n",
    $nbsp{'x x'},
    # save the new code reference and get back the old one
    tied(%nbsp)->config(
        sub => sub {return 'a'},
    ),
    $nbsp{'x x'},
    # save the new auto build code reference and get back the old one
    tied(%nbsp)->config(
        separator => 'b',
    ),
    $nbsp{'x x'};

# result:
# x&nbsp;x
# CODE(0x236024)
# a
# CODE(0x1832954)
# xbx

# $Id$