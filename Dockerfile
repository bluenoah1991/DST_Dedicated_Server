FROM ubuntu:trusty

MAINTAINER codemeow codemeow@yahoo.com

RUN cp /etc/apt/sources.list /etc/apt/sources.list.raw
ADD https://github.com/codemeow5/Scripts/raw/master/ubt_1404_aliyun_sources.list /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install wget -y

# Ref http://forums.kleientertainment.com/topic/64441-dedicated-server-quick-setup-guide-linux/

# Install dependencies
RUN apt-get install libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 -y

# Install steamcmd
RUN mkdir /root/steamcmd
WORKDIR /root/steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -zxvf steamcmd_linux.tar.gz

# Create your dedicated server folders
RUN mkdir -p /root/.klei/DoNotStarveTogether/MyDediServer/Master
RUN mkdir -p /root/.klei/DoNotStarveTogether/MyDediServer/Caves
COPY cluster_token.txt /root/.klei/DoNotStarveTogether/MyDediServer/cluster_token.txt

# Create your cluster.ini file
COPY cluster.ini /root/.klei/DoNotStarveTogether/MyDediServer/cluster.ini

# Create your Master server.ini
COPY master_server.ini /root/.klei/DoNotStarveTogether/MyDediServer/Master/server.ini

# Create your Caves server.ini
COPY cave_server.ini /root/.klei/DoNotStarveTogether/MyDediServer/Caves/server.ini

# Create your Master worldgenoverride.lua
COPY master_worldgenoverride.lua /root/.klei/DoNotStarveTogether/MyDediServer/Master/worldgenoverride.lua

# Create your Caves worldgenoverride.lua
COPY cave_worldgenoverride.lua /root/.klei/DoNotStarveTogether/MyDediServer/Caves/worldgenoverride.lua

# Create the script that will run the servers
COPY run_dedicated_servers.sh /root/run_dedicated_servers.sh
RUN chmod u+x /root/run_dedicated_servers.sh

ENTRYPOINT /root/run_dedicated_servers.sh
