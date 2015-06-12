#!/usr/bin/python

cmdsfile = open('cmds.in','r')
datafile = open('cmds.out','r')

cmds = []
for c in cmdsfile:
	c = c.strip()
	c = c.rstrip()
	cmds.append(c)

data = {}
idx = 0
for l in datafile:
	l = l.strip()
	l = l.rstrip()
	if len(l) == 0:
		continue
	if l in cmds: 	
		idx = idx + 1
		data[idx-1] = []
	else:
		data[idx-1].append(l)

for k in data:
	print "********" + cmds[k] + "********"
	for l in data[k]:
		print l + "\n",
