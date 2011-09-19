#!/usr/bin/env perl
use Test::Most;
use Net::Ping;

BEGIN {
  plan skip_all => 'Needs Google+ API key in %ENV'
    unless $ENV{GOOGLE_PLUS_API_KEY};

  my $p = Net::Ping->new('syn', 2);
  $p->port_number(getservbyname(https => 'tcp'));
  $p->service_check(1);
  plan skip_all => 'Needs access to remote Google API endpoint'
    unless $p->ping('www.googleapis.com');
}

# Google+Zak
my $user_id = '112708775709583792684';

use Google::Plus;

can_ok 'Google::Plus' => 'new';

throws_ok { Google::Plus->new } qr/key.+required/, 'needs API key';
throws_ok { Google::Plus->new(blah => 'ther') } qr/key.+required/, 'bad key';

my $g = Google::Plus->new(key => $ENV{GOOGLE_PLUS_API_KEY});
isa_ok $g => 'Google::Plus';

can_ok $g => 'person';

throws_ok { $g->person } qr/ID.+required/, 'needs user ID';
throws_ok { $g->person('foo') } qr/Invalid/, 'user ID must be numeric';
throws_ok { $g->person('00000000000000000000') } qr/unable to map/,
  'bad person';

my $p = $g->person($user_id);
isa_ok $p => 'Google::Plus::Person';

TODO: {
  local $TODO = 'test driven development!';


}

done_testing;
