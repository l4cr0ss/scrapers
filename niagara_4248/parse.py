#!/usr/bin/python
# Functions to parse output collected from a Niagra 4248
# Author: Jefferson Hudson

import collections
import mods

# Dump the parsed output to stdout
def dump_output(datad):
	for k,v in datad.items():
		print k,':',v

# Load the commands into a list to function as an index
def load_cmds(file):
	cmds = []
	for c in file:
		c = c.strip()
		c = c.rstrip()
		cmds.append(c)
	return cmds

# Build data dictionary of commands and output
# data[KEY] -> [line1,line2,...,lineN]
# where KEY is an index of `cmds`
def load_dd(cmds,file):
	data = {}
	idx = 0
	for l in file:
		l = l.strip()
		l = l.rstrip()
		if len(l) == 0:
			continue
		if l in cmds: 	
			idx = idx + 1
			data[idx-1] = []
		else:
			data[idx-1].append(l)
	return data

def Main():
	# Open the command and datafile
	cmdsf = open('cmds.in','r')
	dataf = open('cmds.out','r')

	# Load the commands and construct the data dictionary
	cmds = load_cmds(cmdsf)
	data = load_dd(cmds,dataf)

	d = collections.OrderedDict()
	d[0] = mods.show_system_info(data[0])
	d[1] = mods.show_port_sfp(data[1])
	d[2] = mods.show_interfaces_status(data[2])
	d[3] = mods.show_ip_interface(data[3])


	# Build the rows to be written to excel
	rows = []
	
	
	for k,v in d.items():
		dump_output(v)

if __name__=="__main__":
	Main()

