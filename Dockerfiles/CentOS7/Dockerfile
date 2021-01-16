# latest CentOS 7 docker image
FROM centos:centos7.9.2009

ENV GIT_REPO https://github.com/MichaelStromberg-Illumina/DotNetMisc/raw/master
ENV BUILD_SH BuildNirvana.sh

RUN yum -y update && \
rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm && \
yum -y install dotnet-sdk-3.1 git && \
yum clean all && \
#
# create our mount point
mkdir /build && \
#
# download our Nirvana build script
curl -SL $GIT_REPO/$BUILD_SH -o /usr/local/bin/$BUILD_SH && \
chmod 755 /usr/local/bin/$BUILD_SH

# define our startup command
CMD /usr/local/bin/$BUILD_SH
