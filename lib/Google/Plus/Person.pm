package Google::Plus::Person;
use Mojo::Base -base;

use Carp;

has [qw/id gender image organizations tagline url urls key ua/];

has about_me     => sub { $_[0]->{aboutMe} };
has display_name => sub { $_[0]->{displayName} };
has places_lived => sub { $_[0]->{placesLived} };

sub new {
  my ($class, $json, $key, $ua) = @_;
  my $self = bless $json => $class;

  $self->key($key);
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

=head2 C<about_me>

  my $about = $person->about_me;

Short biography of this person.

=head2 C<display_name>

  my $name = $person->display_name;

Name of person, suitable for display.

=head2 C<gender>

  my $gender = $person->gender;

Person's gender.

=head2 C<id>

  my $id = $person->id;

Numeric user ID, e.g. C<112708775709583792684>.

=head2 C<image>

  my $image = $person->image;

URL of this person's profile photo.

=head2 C<organizations>

  my @organizations = $person->organizations;

List of organizations this person is a member of.

=head2 C<places_lived>

  my @places_lived = $person->places_lived;

List of current and previous places this person lived in.

=head2 C<tagline>

  my $tagline = $person->tagline;

Brief description (tagline) of this person.

=head2 C<url>

  my $url = $person->url;

URL of this person's profile,
e.g. L<https://plus.google.com/112708775709583792684/posts>.

=head2 C<urls>

  my @urls = $person->urls;

List of URLs associated with this person.

=head1 METHODS

L<Google::Plus::Person> implements the following methods:

=head2 new

  my $person = Google::Plus::Person->new($hashref);

Construct a new L<Google::Plus::Person> object from the given hashref
(typically output from L<Mojo::JSON>.)

=head1 SEE ALSO

L<Google::Plus>, L<http://developers.google.com/+/api/latest/people>

=cut
