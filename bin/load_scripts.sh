#!/bin/bash

# run from stream.il2missionplanner.com top level directory

echo "Loading scripts..."
for f in lua/*.lua
do
	base=`basename $f`
	filename=${base%.lua}
	echo $filename
	hashcode=`redis-cli script load "$(cat $f)"`
	echo $hashcode
	redis-cli hset scripts $filename $hashcode
done

echo "Setting default TTL..."
redis-cli set stream_ttl 10800

echo "Done."
