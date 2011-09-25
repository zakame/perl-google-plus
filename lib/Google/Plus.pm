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

sub activities {
  my ($self, $user_id, $next_token) = @_;

  croak 'user ID required' unless $user_id;
  croak 'Invalid user ID' unless $user_id =~ /[0-9]+/;

  my $key = $self->key;
  my $ua  = $self->ua;
  my $url =
    "https://www.googleapis.com/plus/v1/people/$user_id/activities/public?";

  $url = join '', $url => "pageToken=$next_token&" if $next_token;
  $url = join '', $url => "key=$key";

  my $json = $ua->get($url)->res->json;

  croak $json->{error}->{message} unless $json->{kind};

  return $json;
}

sub activity {
  my ($self, $activity_id) = @_;

  croak 'activity ID required' unless $activity_id;
  croak 'Invalid activity ID' unless $activity_id =~ /\w+/;

  my $key = $self->key;
  my $ua  = $self->ua;
  my $url =
    "https://www.googleapis.com/plus/v1/activities/$activity_id?key=$key";

  my $json = $ua->get($url)->res->json;

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
  my $user_id = '112708775709583792684';
  my $person  = $plus->person($user_id);
  say "Name: ", $person->{displayName};

  # get this person's activities
  my $activities = $plus->activities($user_id);
  while ($activities->{nextPageToken}) {
    my $next = $activities->{nextPageToken};
    for my $item (@{$activities->{items}}) {
      ...;
    }
    $activities = $plus->activities($user_id, $next);
  }

  # get a specific activity
  my $post = 'z13uxtsawqqwwbcjt04cdhsxcnfyir44xeg';
  my $act  = $plus->activity($post);
  say "Activity: ", $act->{title};

=head1 DESCRIPTION

This module lets you access Google+ people profiles and activities from
Perl.  Currently, only access to public data is supported; authenticated
requests for C<me> and other private data will follow in a future
release.

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

  my $person = $plus->person('userId');

Get a Google+ person's public profile.  Returns a L<Mojo::JSON> decoded
hashref describing the person's profile in L<Portable
Contacts|http://portablecontacts.net/draft-spec.html> format.

=head2 C<activities>

  my $acts = $plus->activities('userId');
  my $acts = $plus->activities('userId', 'nextPageToken');

Get person's list of public activities.  Returns a L<Mojo::JSON> decoded
hashref describing the person's activities in L<Activity
Streams|http://activitystrea.ms/specs/json/1.0> format.  If
C<nextPageToken> is given, this method retrieves the next page of
activities this person has.

=head2 C<activity>

  my $post = $plus->activity('activityId')

Get a specific activity/post.  Returns a L<Mojo::JSON> decoded hashref
describing the activity in L<Activity
Streams|http://activitystrea.ms/specs/json/1.0> format.

=head1 SEE ALSO

=over

=item * L<Google+ API|http://developers.google.com/+/api>

=item * L<Google+|https://plus.google.com>

=item * L<Portable Contacts Spec|http://portablecontacts.net>

=item * L<Activity Streams Spec|http://activitystrea.ms>

=back

=cut

=head1 DEVELOPMENT

This project is hosted on Github, at
L<https://github.com/zakame/perl-google-plus>.

=head1 AUTHOR

Zak B. Elep, C<zakame@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011, Zak B. Elep.

This is free software, you can redistribute it and/or modify it under
the same terms as Perl language system itself.

=cut
