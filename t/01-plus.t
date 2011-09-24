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
}

use Google::Plus;

# Google+Zak
my $user_id = '112708775709583792684';

my $g;
subtest 'create object' => sub {
  can_ok 'Google::Plus' => 'new';
  throws_ok { Google::Plus->new } qr/key.+required/, 'needs API key';
  throws_ok { Google::Plus->new(blah => 'ther') } qr/key.+required/,
    'bad key';

  $g = Google::Plus->new(key => $ENV{GOOGLE_PLUS_API_KEY});
  ok ref $g => 'Made object';
  isa_ok $g => 'Google::Plus';
};

my $p;
subtest 'get person profile' => sub {
  can_ok $g => 'person';

  throws_ok { $g->person } qr/ID.+required/, 'needs user ID';
  throws_ok { $g->person('foo') } qr/Invalid/, 'user ID must be numeric';
  throws_ok { $g->person('00000000000000000000') } qr/unable to map/,
    'bad person';

  my $p = $g->person($user_id);
  isa_ok $p => 'HASH';

  subtest 'person properties' => sub {
    ok $p->{$_}, "$_ exists"
      for qw/ aboutMe displayName gender id image organizations placesLived
      tagline url urls /;
  };
};

my $a;
subtest 'get person activities' => sub {
  can_ok $g => 'activities';

  throws_ok { $g->activities } qr/ID.+required/, 'needs user ID';
  throws_ok { $g->activities('foo') } qr/Invalid/, 'user ID must be numeric';
  throws_ok { $g->activities('00000000000000000000') } qr/unable to map/,
    'bad person';

  my $a = $g->activities($user_id);
  isa_ok $a => 'HASH';

  subtest 'activity list properties' => sub {
    ok $a->{$_}, "$_ exists"
      for qw/ id items nextLink nextPageToken selfLink title updated /;
  };
};

TODO: {
  local $TODO = 'test driven development!';

}

done_testing;
