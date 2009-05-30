#!perl

use strict;
use warnings;

our $VERSION = 0;

use Locale::Maketext::TieHash::nbsp;

tie my %nbsp, 'Locale::Maketext::TieHash::nbsp'; ## no critic (Ties)
() = print $nbsp{'15 pieces'};

# result: '15&nbsp;pieces'

# $Id$