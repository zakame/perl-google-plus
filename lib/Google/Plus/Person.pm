package Google::Plus::Person;
use Mojo::Base -base;

use Carp;

has [
  qw/about_me display_name gender image organizations
    places_lived tag_line url urls id key json ua/
];

sub new {
  my $self = bless {}, shift;
  my ($user_id, $json, $key, $ua) = @_;

  $self->json($json);
  $self->key($key);
  $self->about_me($json->{aboutMe});
  $self->display_name($json->{displayName});
  $self->gender($json->{gender});

  # $self->image(Google::Plus::Person::Image->new($json->{image}, $ua));
  $self->image($json->{image});

  # $self->organizations(
  #   Google::Plus::Organizations->new($json->{organizations}, $ua));
  # $self->places_lived(
  #   Google::Plus::Person::Places->new($json->{places_lived}, $ua));
  $self->tag_line($json->{tag_line});
  $self->url($json->{url});

  # $self->urls(Google::Plus::Person::URLs->new($json->{urls}, $ua));
  $self->id($json->{id});
  $self->ua($ua);

  return $self;
}

1;

__END__

=head1 NAME

Google::Plus::Person - profile of a Google+ person

=head1 SYNOPSIS

  use Google::Plus;
  my $plus = Google::Plus->new($google_plus_api_key);

  # Get my profile
  my $person = Google::Plus->person('112708775709583792684')

  use v5.10.1;
  say "Name: ", $person->display_name;
  say "Tag Line: ", $person->tag_line;

=head1 DESCRIPTION

L<Google::Plus::Person> is a class for Google+ profiles as described in
L<http://developers.google.com/+/api/latest/people>.

=head1 ATTRIBUTES

L<Google::Plus::Person> implements the following attributes:

=head2 id

  my $id = $person->id;

Numeric user ID, e.g. C<112708775709583792684>.

=head2 about_me

Short biography of this person.

=head2 display_name

Name of person, suitable for display.

=head2 image

URL of this person's profile photo.

=head2 gender

Person's gender.

=head2 tag_line

Brief description (tagline) of this person.

=head2 url

URL of this person's profile,
e.g. L<https://plus.google.com/112708775709583792684/posts>.

=head1 METHODS

L<Google::Plus::Person> implements the following methods:

=head2 new

  my $person = Google::Plus::Person->new($user_id, $json, $key, $ua);

Construct a new L<Google::Plus::Person> object from the given user ID.
If given a hash reference holding profile information, populate the
object's attributes with it.

=head1 SEE ALSO

L<Google::Plus>, L<http://developers.google.com/+/api/latest/people>

=cut
