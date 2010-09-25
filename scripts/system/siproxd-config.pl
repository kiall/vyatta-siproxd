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

my ($setup_siproxd, $update_siproxd, $stop_siproxd);

GetOptions(
    "setup!"    => \$setup_siproxd,
    "update!"   => \$update_siproxd,
    "stop!"     => \$stop_siproxd
);

if ($setup_siproxd) {
	system("sudo iptables -t nat -N SIPROXD");
	system("sudo iptables -t nat -I VYATTA_PRE_DNAT_HOOK 1 -j SIPROXD");
	exit 0;
}

if ($update_siproxd) {
	exit 0;
}

if ($stop_siproxd) {
	system("sudo iptables -t nat -D VYATTA_PRE_DNAT_HOOK -j SIPROXD");
	system("sudo iptables -t nat -F SIPROXD");
	system("sudo iptables -t nat -X SIPROXD");

	exit 0;
}

exit 1;

# end of file

