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
	my $orig_listen_port = $config->returnOrigValue("service sip-proxy listen-on $interface listen-port");
	my $listen_port = $config->returnValue("service sip-proxy listen-on $interface listen-port");

	my $orig_siproxd_port = $config->returnOrigValue("service sip-proxy listen-on $interface siproxd-port");
	my $siproxd_port = $config->returnValue("service sip-proxy listen-on $interface siproxd-port");

	if (defined $orig_listen_port && $orig_listen_port != $listen_port) {
		system("sudo iptables -t nat -D SIPROXD -m udp -p udp -i $interface --destination-port $orig_listen_port -j REDIRECT");
		system("sudo iptables -t nat -A SIPROXD -m udp -p udp -i $interface --destination-port $listen_port -j REDIRECT --to-port $siproxd_port");
	} elsif (!defined $orig_listen_port) {
		system("sudo iptables -t nat -A SIPROXD -m udp -p udp -i $interface --destination-port $listen_port -j REDIRECT --to-port $siproxd_port");
	}

	restart_daemon($interface);

	exit 0;
}

if ($stop_siproxd) {
	# Sometimes the rule is already gone (eg "delete service sip-proxy")
	my $listen_port = $config->returnOrigValue("service sip-proxy listen-on $interface listen-port");

	system("sudo iptables -t nat -D SIPROXD -m udp -p udp -i $interface --destination-port $listen_port -j REDIRECT &> /dev/null");

	stop_daemon($interface);
	exit 0;
}

exit 1;

# end of file

