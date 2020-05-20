#!/bin/sh

if [ ! -f "/build/Nirvana.sln" ]
then 
	echo -e "ERROR: Could not find /build/Nirvana.sln. Did you mount the volume in Docker?"
	exit 1
fi

# grab the major OS version
MAJOR_VER="$(rpm --eval %{centos_ver})"

# check if we have the CentOS 6 version of libBlockCompression.so
echo '2ed28ea95d88c238df90c244b9409d92  /build/Compression/Packages/BlockCompression/libBlockCompression.so' | md5sum --status -c
CENTOS6_LIB_STATUS=$?

if [ $MAJOR_VER == "6" ] && [ $CENTOS6_LIB_STATUS -eq 1 ]
then
	echo "Detected CentOS6 and an invalid compression library: updating libBlockCompression.so"
	cp /usr/local/lib/libBlockCompression.so /build/Compression/Packages/BlockCompression
fi

cd /build

# check if we need to upgrade the projects
if grep -q "netcoreapp2.1" Nirvana/Nirvana.csproj
then
	# update all projects to .NET core 3.1
	echo "Updating all projects to .NET Core 3.1"
	find . -name "*.csproj" -exec sed -i 's/netcoreapp2.1/netcoreapp3.1/g' {} \;
	
	# add single file assembly
	echo "Adding single file assembly updates to csproj files"
	SED_REPLACE='s/<\/PropertyGroup>/  <PublishTrimmed>true<\/PublishTrimmed>\n    <PublishReadyToRun>true<\/PublishReadyToRun>\n    <PublishSingleFile>true<\/PublishSingleFile>\n  <\/PropertyGroup>\n  <ItemGroup>\n    <RuntimeHostConfigurationOption Include="System.Globalization.Invariant" Value="true" \/>\n  <\/ItemGroup>/g'
	sed -i "$SED_REPLACE" Nirvana/Nirvana.csproj
	sed -i "$SED_REPLACE" Downloader/Downloader.csproj
fi

# set the appropriate runtime ID
RUNTIME_ID=linux-x64

if [ $MAJOR_VER == "6" ]
then
	RUNTIME_ID=rhel.6-x64
fi

# get the git version
NIRVANA_VER="$(git describe --long | cut -c2-)"

# build Nirvana
cd /build/Nirvana
dotnet publish -r $RUNTIME_ID -c Release /property:Version=$NIRVANA_VER

# build Downloader
cd ../Downloader
dotnet publish -r $RUNTIME_ID -c Release /property:Version=$NIRVANA_VER
