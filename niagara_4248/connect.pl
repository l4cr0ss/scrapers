#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

use Expect;
$Expect::Debug=1;
use Switch;
my $filename = 'app.ini';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# Load the configuration parameters
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

my $prompt = '/[\$%#>] $/';
my $timeout = 3;

# Create the expect object
my $e = Expect->new();
$e->spawn('telnet', $host);
$e->expect($timeout, 'login:','-re',$prompt);
