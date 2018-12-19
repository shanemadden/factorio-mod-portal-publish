#!/bin/sh

sh -c "echo $*"
sh -c "echo \"${GITHUB_REF}\""
sh -c "TAG=$(echo \"${GITHUB_REF}\" | grep tags | grep -o \"[^/]*\" ) && echo \"building ${TAG}\" && zip -r $1_${TAG}.zip . $1 -x \*.git\* && curl -X POST -F \"file=@$1_${TAG}.zip\" https://mods.factorio.com/mod/$1/downloads/edit?username=${FACTORIO_USER}&token=${FACTORIO_TOKEN} && echo done"
