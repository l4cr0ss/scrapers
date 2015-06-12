#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

#use strict;
use warnings;
use Switch;
use Net::Telnet qw(TELOPT_NAWS);
use Net::Telnet qw(TELNET_IAC);
use Net::Telnet();

# Load the configuration from the file app.ini
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

# Generic shell prompt
my $prompt = '/[\$%#>] $/';
my $more = '/--More--/';
my $regex = "/$prompt||$more/";
my $show_info = 'show system info';



# Telnet objects
my $t;

$t = new Net::Telnet (Timeout => 10,
                      Prompt => '/[\$%#>] $/',
		      Errmode => 'return',
                      Input_log => 'input.log', 
                      Output_log => 'output.log',
                      Option_log => 'option.log',		
                      Dump_log => 'dump.log');

$t->open($host);
$t->login($user, $pass);

$t->print("show port sfp");
my @lines = $t->waitfor($more);
print @lines;

