package Locale::Maketext::TieHash::nbsp;

use 5.006001;
use strict;
use warnings;
use Carp qw(croak);

our $VERSION = '0.02';

require Tie::Hash;
our @ISA = qw(Tie::Hash);

sub TIEHASH
{ bless {
    sub => sub {
      (local $_ = $_[0]) =~ s/ /&nbsp;/g;
      $_;
    }
  }, shift;
}

# Store your own subroutine.
sub STORE
{ # Object, Key, Value
  my ($self, $key, $value) = @_;
  $key or croak 'key is not true';
  $key eq 'sub' or croak "key is not 'sub'";
  ref $value eq 'CODE' or croak 'Reference on CODE expects.';
  $self->{$key} = $value;
}

# execute the sub
sub FETCH
{ # Object, Key
  my ($self, $key) = @_;
  # Several parameters to sub will submit as reference on an array.
  $self->{sub}->(ref $key eq 'ARRAY' ? @{$key} : $key);
}

1;
__END__

=head1 NAME

Locale::Maketext::TieHash::nbsp - Tying subroutine to a hash

=head1 SYNOPSIS

 use strict;
 use Locale::Maketext::TieHash::nbsp;
 tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';
 # print: "15&nbsp;pieces";
 print $nbsp{15 pieces};
 # If you want to test your Script, store you yours own test subroutine.
 # Substitute whitespace to a string which you see in the Browser.
 $nbsp{sub} = sub {
   (local $_ = $_[1]) =~ s/ /<span style="color:red">§</span>/g;
 };

=head1 DESCRIPTION

Subroutines don't have interpreted into strings.
The module ties a subroutine to a hash.
The Subroutine is executed at fetch hash.
At long last this is the same, only the notation is shorter.

Sometimes the subroutine C<">subC<"> expects more than 1 parameter.
Then submit a reference on an array as hash key.

=head1 METHODS

=head2 TIEHASH

 use Locale::Maketext::TieHash::nbsp;
 tie my %nbsp, 'Locale::Maketext::TieHash::nbsp';

C<">TIEHASHC<"> ties your hash and set options defaults.

=head2 STORE

C<">STOREC<"> stores your own subroutine.

 $nbsp{sub} = sub {   # this sub is the default
   (local $_ = $_[0]) =~ s/ /&nbsp;/g;
   $_;
 };

The method calls croak, if the key of your hash is undef or your key isn't correct
and if the value, you set to key C<">subC<">, is not a reference of C<">CODEC<">. 

=head2 FETCH

Give your string as key of your hash.
C<">FETCHC<"> will substitute the whitespace in C<">&nbsp;C<"> and give it back as value.

 # Substitute
 print $nbsp{$string};

=head1 SEE ALSO

Tie::Hash

Locale::Maketext

Locale::Maketext::TieHash::L10N

Locale::Maketext::TieHash::quant

=head1 AUTHOR

Steffen Winkler, E<lt>cpan@steffen-winkler.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, 2005 by Steffen Winkler

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.6.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
