# GitHub Action for Factorio Mod Portal Publish

Publishes a repo that contains a factorio mod to the mod portal using the passed secrets FACTORIO_USER and FACTORIO_PASSWORD

## Usage
An example workflow to publish new versions of a mod you have access to named `mod-name`:


```
workflow "Publish mod to portal" {
  on = "push"
  resolves = ["shanemadden/factorio-mod-portal-publish@master"]
}

action "shanemadden/factorio-mod-portal-publish@master" {
  uses = "shanemadden/factorio-mod-portal-publish@master"
  args = "mod-name"
  secrets = ["FACTORIO_USER", "FACTORIO_PASSWORD"]
}

```
