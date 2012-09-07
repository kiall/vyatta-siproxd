#!/usr/bin/perl
#
# Module: Vyatta::Siproxd.pm
# 
# **** License ****
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# This code was originally developed by Managed I.T.
# Portions created by Managed I.T. are Copyright (C) 2010 Managed I.T.
# All Rights Reserved.
# 
# Author: Kiall Mac Innes
# Date: May 2010
# Description: Script to configure sip proxy (siproxd).
# 
# **** End License ****
#

use Getopt::Long;
use POSIX;

use lib '/opt/vyatta/share/perl5';
use Vyatta::Config;
use Vyatta::Siproxd;

use warnings;
use strict;

my $config = new Vyatta::Config;

my ($setup_siproxd, $update_siproxd, $stop_siproxd, $interface);

GetOptions(
    "setup!"    => \$setup_siproxd,
    "update!"   => \$update_siproxd,
    "stop!"     => \$stop_siproxd,
    "dev=s"     => \$interface,
);

if ($setup_siproxd) {
	exit 0;
}

if ($update_siproxd) {
	siproxd_generate_config($interface);
	restart_daemon($interface);

	exit 0;
}

if ($stop_siproxd) {
	stop_daemon($interface);
	exit 0;
}

exit 1;

# end of file

