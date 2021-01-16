# latest CentOS 6 docker image
FROM centos:centos6.10

ENV GIT_REPO https://raw.githubusercontent.com/MichaelStromberg-Illumina/DotNetMisc/master
ENV BASE_REPO CentOS6-Base.repo
ENV DOTNET_TGZ dotnet-sdk-3.1.201-rhel.6-x64.tar.gz
ENV CURL_TGZ curl-7_45_0-RHEL6-x64.tgz
ENV ICU_TGZ icu4c-57_1-RHEL6-x64.tgz 
ENV BUILD_SH BuildNirvana.sh

# update our OS
RUN curl -SL $GIT_REPO/$BASE_REPO -o /etc/yum.repos.d/CentOS-Base.repo && \
yum -y update && \
yum -y upgrade && \
yum -y install git && \
yum clean all && \
#
# install .NET Core 3.1 SDK
mkdir /opt/dotnet && \
curl -SLO https://download.visualstudio.microsoft.com/download/pr/a411f02e-eae9-48f0-a026-d1b4d3fabd07/464e5524dbf492d7584b1ba666fa0881/$DOTNET_TGZ && \
tar xzC /opt/dotnet -f $DOTNET_TGZ && \
rm $DOTNET_TGZ && \
#
# install special curl library for .NET Core
curl -SLO $GIT_REPO/$CURL_TGZ && \
tar xzC / -f $CURL_TGZ && \
rm $CURL_TGZ && \
#
# install special icu library for .NET Core
curl -SLO $GIT_REPO/$ICU_TGZ && \
tar xzC / -f $ICU_TGZ && \
rm $ICU_TGZ && \
#
# create our mount point
mkdir /build && \
#
# download our Nirvana build script
curl -SL $GIT_REPO/$BUILD_SH -o /usr/local/bin/$BUILD_SH && \
chmod 755 /usr/local/bin/$BUILD_SH && \
#
# download the CentOS 6 version of BlockCompression
curl -SL $GIT_REPO/lib_centos6/libBlockCompression.so -o /usr/local/lib/libBlockCompression.so && \
#
# create our dotnet wrapper (automatically applies LD_LIBRARY_PATH hack)
curl -SL $GIT_REPO/dotnet-wrapper.sh -o /usr/bin/dotnet && \
chmod 755 /usr/bin/dotnet

# define our startup command
CMD /usr/local/bin/$BUILD_SH
