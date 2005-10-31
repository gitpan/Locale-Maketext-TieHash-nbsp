use 5.006001;
use strict;
use warnings;
use Test::More tests => 7;
BEGIN { use_ok('Locale::Maketext::TieHash::nbsp') };

tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';
{ ok
    '&nbsp;' eq $nbsp{' '},
    'check transformation'
  ;
}
{ my $sub = sub {
    my ($p1, $p2) = @_;
    "$p1$p2";
  };
  tied(%nbsp)->Config(sub => $sub);
  my %cfg = tied(%nbsp)->Config();
  ok
    $cfg{sub} eq $sub,
    'save and get back subroutine, use method Config'
  ;
};
{ ok
    $nbsp{[1,2]} eq '12',
    'check substituted subroutine'
  ;
}
{ eval { tied(%nbsp)->Config(undef() => undef) };
  my $error1 = $@ || '';
  eval { tied(%nbsp)->Config(wrong => undef) };
  my $error2 = $@ || '';
  eval { tied(%nbsp)->Config(sub => []) };
  my $error3 = $@ || '';
  ok
    $error1 =~ /\bkey is not true\b/
    && $error2 =~ /\bkey is not 'sub'/
    && $error3 =~ /\b\QReference on CODE expects.\E/,
    'initiating dying by storing wrong reference'
  ;
}
{ $nbsp{sub} = sub{shift};
  ok
    $nbsp{1},
    'substitute subroutine, use deprecated method STORE'
  ;
}
{ eval { no warnings; $nbsp{undef()} = undef };
  my $error1 = $@ || '';
  eval { $nbsp{wrong} = undef };
  my $error2 = $@ || '';
  eval { $nbsp{sub} = [] };
  my $error3 = $@ || '';
  ok
    $error1 =~ /\bkey is not true\b/
    && $error2 =~ /\bkey is not 'sub'/
    && $error3 =~ /\b\QReference on CODE expects.\E/,
    'initiating dying by storing wrong reference, use deprecated method STORE'
  ;
}