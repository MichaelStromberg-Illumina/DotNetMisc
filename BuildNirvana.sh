#!/bin/sh

if [ ! -f "/build/Nirvana.sln" ]
then
	echo -e "ERROR: Could not find /build/Nirvana.sln. Did you mount the volume in Docker?"
	exit 1
fi

cd /build

# check if we need to upgrade the projects
if grep -q "netcoreapp3.1" Nirvana/Nirvana.csproj
then
	# update all projects to .NET 5.0
	echo "Updating all projects to .NET 5.0"
	find . -name "*.csproj" -exec sed -i 's/netcoreapp3.1/net5.0/g' {} \;

	# add single file assembly
	echo "Adding single file assembly updates to csproj files"
	SED_REPLACE='s/<\/PropertyGroup>/  <PublishTrimmed>true<\/PublishTrimmed>\n    <IncludeAllContentForSelfExtract>true<\/IncludeAllContentForSelfExtract>\n    <PublishReadyToRun>true<\/PublishReadyToRun>\n    <PublishSingleFile>true<\/PublishSingleFile>\n  <\/PropertyGroup>\n  <ItemGroup>\n    <RuntimeHostConfigurationOption Include="System.Globalization.Invariant" Value="true" \/>\n  <\/ItemGroup>/g'
	sed -i "$SED_REPLACE" Nirvana/Nirvana.csproj
	sed -i "$SED_REPLACE" Downloader/Downloader.csproj
fi

# set the appropriate runtime ID
RUNTIME_ID=linux-x64

# get the git version
NIRVANA_VER="$(git describe --long | cut -c2-)"

# build Nirvana
cd /build/Nirvana
dotnet publish -r $RUNTIME_ID -c Release /property:Version=$NIRVANA_VER

# build Downloader
cd ../Downloader
dotnet publish -r $RUNTIME_ID -c Release /property:Version=$NIRVANA_VER
