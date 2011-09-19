#!/usr/bin/env perl
use Test::Most;
use Mojo::UserAgent;
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

my $key = $ENV{GOOGLE_PLUS_API_KEY};

use Google::Plus;

my $g = Google::Plus->new(key => $key);

can_ok 'Google::Plus::Person' => 'new';

my $p = $g->person($user_id);
isa_ok $p => 'Google::Plus::Person';

ok $p->$_, "$_ exists"
  for qw/ about_me display_name gender id image organizations places_lived
  tagline url urls key ua /;

TODO: {
  local $TODO = 'test driven development!';

}

done_testing;
