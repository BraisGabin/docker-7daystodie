FROM dstacademy/steamcmd:0.2.2

ENV DTD7_HOME "/opt/7dtd"

#Install dependencies
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
    xvfb \
	&& apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install 7 Days to Die Server.
RUN set -x \
	&& mkdir -p $DTD7_HOME \
	&& chown $STEAM_USER:$STEAM_USER $DTD7_HOME \
	&& sync \
	&& gosu $STEAM_USER steamcmd \
		+@ShutdownOnFailedCommand 1 \
		+login anonymous \
		+force_install_dir $DTD7_HOME \
		+app_update 294420 \
      validate \
		+quit \
	&& rm -rf $STEAM_HOME/Steam/logs $STEAM_HOME/Steam/appcache/httpcache \
  && find $STEAM_HOME/package -type f ! -name "steam_cmd_linux.installed" ! -name "steam_cmd_linux.manifest" -delete

# Set default values to environment variables
ENV CONFIG_FILE "serverconfig.xml"

# Copy common scripts
COPY /script/* /usr/local/bin/

# Expose default server ports
EXPOSE 8080-8082 26900 26900-26902/udp

# Set default command
CMD ["7DaysToDieServer"]
