use 5.006001;
use strict;
use warnings;
use Test::More tests => 5;
BEGIN { use_ok('Locale::Maketext::TieHash::nbsp') };

use Locale::Maketext::TieHash::nbsp;
tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';
print "# check transformation\n";
ok '&nbsp;' eq $nbsp{' '};
print "# change subroutine\n";
$nbsp{sub} = sub {
  my ($p1, $p2) = @_;
  "$p1$p2";
};
ok 1;
print "# check changed subroutine\n";
ok $nbsp{[1,2]} eq '12';
print "# initiating dying by storing wrong reference\n";
{ eval { no warnings; $nbsp{undef()} = undef };
  my $error1 = $@ || '';
  eval { $nbsp{wrong} = undef };
  my $error2 = $@ || '';
  eval { $nbsp{sub} = [] };
  my $error3 = $@ || '';
  ok $error1 =~ /\bkey is not true\b/ && $error2 =~ /\bkey is not 'sub'/ && $error3 =~ /\b\QReference on CODE expects.\E/;
}
