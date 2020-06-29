import fileinput
import re
import sys
from ast import literal_eval
 
rdict= literal_eval('{'+str(sys.argv[2])+'}')

for line in fileinput.input(sys.argv[1], inplace=1):
	for src, target in rdict.iteritems():
		line = re.sub(src,target, line.rstrip())
    	print(line)
fileinput.close()
