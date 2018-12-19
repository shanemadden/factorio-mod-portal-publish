#!/bin/sh

TAG=$(sh -c "echo \"${GITHUB_REF}\" | grep tags | grep -o \"[^/]*$\"")

zip -r $1_${TAG}.zip . $1 -x \*.git\*

curl -v google.com

#sh -c "curl -v -X POST -F \"file=@$1_${TAG}.zip\" https://mods.factorio.com/mod/$1/downloads/edit?username=${FACTORIO_USER}&token=${FACTORIO_TOKEN}"
curl -v https://mods.factorio.com/mod/$1/downloads/edit
