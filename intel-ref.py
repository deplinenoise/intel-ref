#! /usr/bin/env python

import sys
import os
import os.path

fn = os.path.abspath(sys.argv[1])
fdir = os.path.split(fn)[0]
applescript = os.path.join(fdir, "launch-skim.applescript")
word = sys.argv[2].lower()

f = open(fn, 'r')

def launch_pdf(pdf, page):
	os.system("osascript %s %s %s" % (applescript, pdf, page))

for line in f:
	pdf,page,kws,descr = line.split(';', 3)
	variants = kws.lower().split('/')
	if word in variants:
		launch_pdf(os.path.join(fdir, pdf), str(int(page) + 1))
		break

f.close()
