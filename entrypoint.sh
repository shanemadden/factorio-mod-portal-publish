#!/bin/sh

sh -c "echo $*"
sh -c "echo \"${GITHUB_REF}\""

TAG=$(sh -c "echo \"${GITHUB_REF}\" | grep tags | grep -o \"[^/]*$\"")

sh -c "echo \"${TAG}\""

sh -c "zip -r $1_${TAG}.zip . $1 -x \*.git\*"

sh -c "ls -la"

sh -c "curl -v google.com"

#sh -c "curl -v -X POST -F \"file=@$1_${TAG}.zip\" https://mods.factorio.com/mod/$1/downloads/edit?username=${FACTORIO_USER}&token=${FACTORIO_TOKEN}"
sh -c "curl -v https://mods.factorio.com/mod/$1/downloads/edit?username=${FACTORIO_USER}&token=${FACTORIO_TOKEN}"

sh -c "echo done"
