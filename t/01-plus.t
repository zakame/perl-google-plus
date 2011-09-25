#!/usr/bin/env perl
use Test::Most;
use Net::Ping;

BEGIN {
  plan skip_all => 'Needs Google+ API key in %ENV'
    unless $ENV{GOOGLE_PLUS_API_KEY};

  my $p = Net::Ping->new('syn', 2);
  $p->port_number(scalar getservbyname(https => 'tcp'));
  $p->service_check(1);
  plan skip_all => 'Needs access to remote Google API endpoint'
    unless $p->ping('www.googleapis.com');

  plan tests => 3;
}

use Google::Plus;

# Google+Zak
my $user_id = '112708775709583792684';

my $g;
subtest 'create object' => sub {
  plan tests => 5;

  can_ok 'Google::Plus' => 'new';
  throws_ok { Google::Plus->new } qr/key.+required/, 'needs API key';
  throws_ok { Google::Plus->new(blah => 'ther') } qr/key.+required/,
    'bad key';

  $g = Google::Plus->new(key => $ENV{GOOGLE_PLUS_API_KEY});
  ok ref $g => 'Made object';
  isa_ok $g => 'Google::Plus';
};

my $person;
subtest 'get person profile' => sub {
  plan tests => 6;

  can_ok $g => 'person';

  throws_ok { $g->person } qr/ID.+required/, 'needs user ID';
  throws_ok { $g->person('foo') } qr/Invalid/, 'user ID must be numeric';
  throws_ok { $g->person('00000000000000000000') } qr/unable to map/,
    'bad person';

  $person = $g->person($user_id);
  isa_ok $person => 'HASH';

  subtest 'person properties' => sub {
    plan tests => 10;

    ok $person->{$_}, "$_ exists"
      for qw/ aboutMe displayName gender id image organizations placesLived
      tagline url urls /;
  };
};

my $activities;
subtest 'get person activities' => sub {
  plan tests => 7;

  can_ok $g => 'activities';

  throws_ok { $g->activities } qr/ID.+required/, 'needs user ID';
  throws_ok { $g->activities('foo') } qr/Invalid/, 'user ID must be numeric';
  throws_ok { $g->activities('00000000000000000000') } qr/unable to map/,
    'bad person';

  $activities = $g->activities($user_id);
  isa_ok $activities => 'HASH';

  subtest 'activity list properties' => sub {
    plan tests => 7;

    ok $activities->{$_}, "$_ in activity list exists"
      for qw/ id items nextLink nextPageToken selfLink title updated /;
  };

  subtest 'next activity list' => sub {
    plan tests => 8;

    my $next = $g->activities($user_id, $activities->{nextPageToken});
    isnt $next->{nextPageToken}, $activities->{nextPageToken},
      'got new activity list (the next page)';
    ok $next->{$_}, "$_ in next activity list exists"
      for qw/ id items nextLink nextPageToken selfLink title updated /;
  };
};

TODO: {
  local $TODO = 'test driven development!';

}
