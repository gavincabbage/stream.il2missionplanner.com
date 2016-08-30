#!/bin/bash

# go through lua directory
# load each script
# save hash as name of script key

# run from stream.il2missionplanner.com top level directory

for f in lua/*.lua
do
	base=`basename $f`
	filename=${base%.lua}
	echo $filename
	hashcode=`redis-cli script load "$(cat $f)"`
	echo $hashcode
	redis-cli hset myScripts $filename $hashcode
done
