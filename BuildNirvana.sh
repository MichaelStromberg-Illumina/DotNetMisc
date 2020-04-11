#!/bin/sh

if [ ! -f "/build/Nirvana.sln" ]
then 
	echo -e "ERROR: Could not find /build/Nirvana.sln. Did you mount the volume in Docker?"
	exit 1
fi

cd /build/Nirvana
dotnet publish -r rhel.6-x64 -c Release

cd ../Downloader
dotnet publish -r rhel.6-x64 -c Release
