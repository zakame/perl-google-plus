package Google::Plus;
use Mojo::Base -base;

use Mojo::UserAgent;
use IO::Socket::SSL 1.37;
use Carp;

has [qw/key ua/];

sub new {
  my $self = bless {}, shift;

  croak "API key required" unless $_[0] and $_[0] eq 'key';

  $self->key($_[1]);
  $self->ua(Mojo::UserAgent->new);

  return $self;
}

sub person {
  my ($self, $user_id) = @_;

  croak 'user ID required' unless $user_id;
  croak 'Invalid user ID' unless $user_id =~ /[0-9]+/;

  my $key = $self->key;
  my $ua  = $self->ua;

  my $json = $ua->get(
    "https://www.googleapis.com/plus/v1/people/$user_id?key=$key"
  )->res->json;

  croak $json->{error}->{message} unless $json->{kind};

  return $json;
}

"Inspired by tempire's Google::Voice :3";

__END__

=head1 NAME

Google::Plus - simple interface to Google+

=head1 SYNOPSIS

  use Google::Plus;
  use v5.10.1;

  my $plus = Google::Plus->new(key => $your_gplus_api_key);

  # get a person's profile
  my $person = $plus->person('112708775709583792684');
  say "Name: ", $person->display_name;

=head1 DESCRIPTION

This module lets you access Google+ people profiles and activities from
Perl.  Currently, only access to public data is supported.

This module is B<alpha> software, use at your own risk.

=head1 ATTRIBUTES

=head2 C<key>

  my $key = $plus->key;
  my $key = $plus->key('xxxxNEWKEYxxxx');

Google+ API key, used for retrieving content.  Usually set using L</new>.

=head2 C<ua>

  my $ua = $plus->ua;
  my $ua = $plus->ua(Mojo::UserAgent->new);

User agent object that retrieves JSON from the Google+ API endpoint.
Defaults to a L<Mojo::UserAgent> object.

=head1 METHODS

L<Google::Plus> implements the following methods:

=head2 C<new>

  my $plus = Google::Plus->new(key => $google_plus_api_key);

Construct a new L<Google::Plus> object.  Needs a valid Google+ API key,
which you can get at L<https://code.google.com/apis/console>.

=head2 C<person>

  my $p = $plus->person('userId');

Get a Google+ person's public profile.  Returns a L<JSON> decoded hashref.

=head2 DEVELOPMENT

This project is hosted on Github, at
L<https://github.com/zakame/perl-google-plus>.

=head1 AUTHOR

Zak B. Elep, C<zakame@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011, Zak B. Elep.

This is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
