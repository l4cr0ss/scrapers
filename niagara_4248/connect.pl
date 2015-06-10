#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

use strict;
use warnings;
use Net::Telnet();
use Switch;
my $filename = 'app.ini';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $user = "";
my $pass = "";
my $host = "";
my $i=0;
for ($i=0; $i<3; $i++) {
  my $row = <$fh>;
  chomp $row;
  switch ($i) {
    case 0  { $user = $row; }
    case 1  { $pass = $row; }
    case 2  { $host = $row; }
  }
}

print "$user\n";
print "$pass\n";
print "$host\n";


#$t = new Net::Telnet (Timeout => 10, Prompt => '/bash\$ $/');
#$t->open($host);
#$t->login($user, $pass);
#@lines = $t->cmd("show system info");
#print @lines;
