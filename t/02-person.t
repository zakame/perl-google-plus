#!/usr/bin/env perl
use Test::Most;
use Mojo::UserAgent;

use Google::Plus::Person;

my $id   = '1337';
my $json = {
  id => $id,
  aboutMe => 'Something to test with.',
  displayName => 'Foo Bar Baz',
  gender => 'mail',
  image => {url => 'http://some/nonexistent/image.jpg'},
  kind => 'plus#person',
  organizations => {},
  placesLived => {},
  tagLine => 'Live long, and prosper',
  url => 'http://plus.google.com/1337/posts',
  urls => {},
};
my $key = 'invalid';
my $ua  = Mojo::UserAgent->new;

TODO: {
  local $TODO = 'test driven development!';

  can_ok 'Google::Plus::Person' => 'new';

  my $p = Google::Plus::Person->new($id, $json, $key, $ua);
  isa_ok $p => 'Google::Plus::Person';

  ok $p->$_, "Profile detail $_ exists"
    for qw/id about_me display_name gender image organizations
    places_lived tag_line url urls id key json ua/;
}

done_testing;
