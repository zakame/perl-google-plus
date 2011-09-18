#!/usr/bin/env perl
use Test::Most;
use Net::Ping;

BEGIN {
  plan skip_all => 'Needs Google+ API key and User ID in %ENV'
    unless $ENV{GOOGLE_PLUS_API_KEY} and $ENV{GOOGLE_PLUS_USER_ID};

  my $p = Net::Ping->new('syn', 2);
  $p->port_number(getservbyname(https => 'tcp'));
  $p->service_check(1);
  plan skip_all => 'Needs access to remote Google API endpoint'
    unless $p->ping('www.googleapis.com');
}

use Google::Plus;

can_ok 'Google::Plus' => 'new';

throws_ok { Google::Plus->new } qr/key.+required/, 'needs API key';
throws_ok { Google::Plus->new(blah => 'ther') } qr/key.+required/, 'bad key';

my $g = Google::Plus->new(key => $ENV{GOOGLE_PLUS_API_KEY});
isa_ok $g => 'Google::Plus';

can_ok $g => 'person';

throws_ok { $g->person } qr/ID.+required/, 'needs user ID';
throws_ok { $g->person('foo') } qr/Invalid/, 'bad person';

my $p = $g->person($ENV{GOOGLE_PLUS_USER_ID});
isa_ok $p => 'Google::Plus::Person';

TODO: {
  local $TODO = 'test driven development!';


}

done_testing;
