# GitHub Action to automatically publish to the Factorio mod portal

Builds and publishes tagged releases of a Factorio mod to the Factorio mod portal.

## Usage
Currently, this action expects a flat repo structure with exactly one complete mod in the git repo (with a valid info.json in the repo's root).

It also expects tag names to match the Factorio mod version numbering scheme - three numbers separated by periods, eg. `1.15.0`.

Non-tag pushes will be ignored, but when a tag is pushed that is valid and matches the version number in info.json, the mod will be zipped up and published to the mod portal using the required secrets `FACTORIO_USER` and `FACTORIO_PASSWORD` to authenticate.

An example workflow to publish tagged releases:

    on: push
    name: Publish
    jobs:
      publish:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@master
        - name: Publish Mod
          uses: shanemadden/factorio-mod-portal-publish@stable
          env:
            FACTORIO_PASSWORD: ${{ secrets.FACTORIO_PASSWORD }}
            FACTORIO_USER: ${{ secrets.FACTORIO_USER }}


`FACTORIO_USER` and `FACTORIO_PASSWORD` secrets should be valid credentials to the Factorio mod portal with permissions to edit the mod defined in info.json.

A valid .gitattributes file is required to filter .git*/* directories. This file must be checked in and tagged to filter during a git-archive operation.

    .gitattributes export-ignore
    .gitignore export-ignore
    .github export-ignore


Be aware that the zip will be published and immediately available for download for users - make sure you're ready to publish the changes and have tested the commit before pushing the tag!
