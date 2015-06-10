#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

use strict;
use warnings;

my $filename = 'app.ini';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $l1 = 1;
my $user = "";
my $pass = "";
for (my $i=0; $i<2; $i++) {
  my $row = <$fh>;
  chomp $row;
  if ($l1 == 1) {
    $user = $row;
    $l1 = 0;
  } else {
    $pass = $row; 
  }
}

print "$user\n";
print "$pass\n";

