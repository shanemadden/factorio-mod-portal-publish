FROM debian:9-slim

LABEL "com.github.actions.name"="Factorio Mod Portal Publish"
LABEL "com.github.actions.description"="Publishes repos with Factorio mods to the Factorio mod portal"
LABEL "com.github.actions.icon"="settings"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/shanemadden/factorio-mod-portal-publish"
LABEL "maintainer"="Shane Madden"

RUN apt-get update && apt-get -y install curl zip jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
