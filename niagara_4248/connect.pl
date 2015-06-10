#!/usr/bin/perl
#
# Connect to the Niagra 4248 via telnet

use strict;
use warnings;

# Import libraries
use Config::Simple;

Config::Simple->import_from('app.ini', \%Config);
