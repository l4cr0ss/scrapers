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

my $prompt = '/[\$%#>] $/';


#my @lines = $t->cmd("show system info");
#print @lines;

my @lines;
my @lines2;
my @lines3;

$t->print("show port sfp");
@lines = $t->waitfor("/--More--/");
$t->print(" ");
@lines2 = $t->waitfor("/--More--/");
$t->print(" ");
@lines3 = $t->waitfor($prompt);
print @lines;
print @lines2;
print "@lines3\n";

my $topts = Net::Telnet::Options->new();
my $t;
$t = new Net::Telnet (Timeout => 10, 
                      Prompt => '/[\$%#>] $/',
                      Input_log => 'input.log', 
                      Output_log => 'output.log',
                      Option_log => 'option.log',		
                      Dump_log => 'dump.log');

$t->option_callback(\&opt_callback);
$t->option_accept([ Do => TELNET_NAWS ])
$t->open($host);
$t->login($user, $pass);
sub opt_callback 
{
	my ($obj, $option, $is_remote, $is_enabled, $was_enabled, $buf_pos) = @_;
	if ($option == TELNET_NAWS and $is_enabled and !$is_remote) {
		$obj->put(TELNET_IAC,TELNET_SB,TELNET_NAWS,"\x03\xE8",TELNET_IAC,TELNET_SE);
	}
}


    ## Indicate that we'll accept an offer from remote side for it to echo
    ## and suppress go aheads.
    &_opt_accept($self,
		 { option    => &TELOPT_ECHO,
		   is_remote => 1,
		   is_enable => 1 },
		 { option    => &TELOPT_SGA,
		   is_remote => 1,
		   is_enable => 1 },
		 );
