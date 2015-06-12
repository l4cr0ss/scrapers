#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

use Expect;
$Expect::Debug=0;
use Switch;

# Load the configuration parameters
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

# Load the commands to be run
$filename = 'cmds.in';
open(my $fh2, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
my @cmds;
while(<$fh2>) {
	chomp;
	push @cmds, $_;
}
close $fh2;
my $num_cmds;
foreach (@cmds) {
	$num_cmds++;
}

my $prompt = '/[\$%#>] $/';
my $more = '/--More--/';
my $timeout = 10;
my @output;

my $e = Expect->new();
$e->log_stdout(0);
$e->spawn('telnet', $host);
$e->expect($timeout, 
	[	
	'login:' => sub {
			my $exp = shift;
			$exp->send($user . "\n");
			exp_continue;
			}
	],
	[
	'Password:' => sub {
			my $exp = shift;
			$exp->send($pass . "\n");
			exp_continue;
			}
	],
	[
	'DUKETEDAGI02#' => sub { 
			my $exp = shift;
			my $cmd = shift @cmds;
			$exp->send($cmd . "\n");
			push @output, $exp->before();
			if ($num_cmds > 0) {
				$num_cmds--;
				exp_continue;
				}
			}
	],
	[
	'\-\-More--' => sub {
			my $exp = shift;
			$exp->send("" . "\n");
			push @output, $exp->before();
			exp_continue;
			}
	]
	);
foreach(@output) {
	print $_;
	}
