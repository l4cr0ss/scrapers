#!/usr/bin/python
# Parsing Modules for the Niagara 4248
# Author: Jefferson Hudson

import collections
import re

def show_system_info(output):
	d = collections.OrderedDict()
	o = output
	for l in o:
		t = l.split(':')
		t1 = t[0].strip().rstrip()
		t2 = t[1].strip().rstrip()
		d[t1] = t2
	return d

def show_port_sfp(output):
	d = collections.OrderedDict()
	o = output

	c = ["Interface", "Vendor", "VPN", "Capabilities"]
	i = 0
	for l in o:
		# Ignore the first two lines: they contain only
		# header information
		if i < 2:
			i = i + 1
			continue

		# Tokenize; delimiter == whitespace >2
		t = re.split(r'\s{2,}',l)

		# Build the data dictionary
		d[t[0]] = {}
		if len(t) == 1:
			d[t[0]] = None
		else:
			for x in range(1,len(t)):
				d[t[0]][c[x]] = t[x]	
	return d

def show_interfaces_status(output):
	d = collections.OrderedDict()
	o = output

	c = ["Port", "Status", "Duplex", "Speed", "Negotiation"]
	i = 0
	for l in o:
		# Ignore the first two lines: they contain only
		# header information
		if i < 2:
			i = i + 1
			continue

		# Tokenize; delimiter == whitespace >2
		t = re.split(r'\s{2,}',l)

		# Build the data dictionary
		d[t[0]] = {}
		for x in range(1,len(t)):
			d[t[0]][c[x]] = t[x]	
	return d

def show_ip_interface(output):
	d = collections.OrderedDict()
	o = output

	# regex for ipv4 + CIDR
	ipv4 = re.compile(r'''(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$''')

	ipv4_cidr = re.compile(r'''(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$''')

	c = ["cpu0", "line_protocol", "ipv4", "broadcast"]
	i = 0
	for l in o:
		if i == 0:
			t = l.split(',')
			t[0] = t[0].split(' ', 1)
			t[1] = t[1].strip().split()
			t[1] = [t[1][0]+' '+t[1][1], t[1][2] +' '+t[1][3]]

			for x in range(0,2):
				if t[x][1] == 'is up':
					d[c[x]] = 'up'
				else:
					d[c[x]] = 'down'
		elif i == 1:
			m = re.search(ipv4_cidr, l)
			d[c[i+1]] = m.group(0)
			
		else:
			m = re.search(ipv4, l)
			d[c[i+1]] = m.group(0)
		i = i + 1
	return d

