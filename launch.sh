#!/bin/bash

set -x

cd /data


if ! [[ -f serverinstall_91_2093 ]]; then
	curl -o serverinstall_91_2093 https://api.modpacks.ch/public/modpack/91/2093/server/linux
	chmod +x serverinstall_91_2093
	./serverinstall_91_2093 --path /data --auto
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
fi

java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm $JVM_OPTS -jar forge-1.16.5-36.2.9.jar nogui