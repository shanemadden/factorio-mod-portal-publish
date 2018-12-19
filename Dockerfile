FROM debian:9-slim

LABEL "com.github.actions.name"="Factorio Mod Portal Publish"
LABEL "com.github.actions.description"="Publishes zipped archives to the Factorio mod portal"
LABEL "com.github.actions.icon"="settings"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="https://github.com/shanemadden/factorio-mod-portal-publish"
LABEL "maintainer"="Shane Madden <shanemadden@fake.email>"

RUN apt-get update && apt-get -y install curl zip

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
