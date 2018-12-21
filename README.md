# GitHub Action to automatically publish to the Factorio mod portal

Builds and publishes tagged releases of a Factorio mod to the Factorio mod portal.

## Usage
Currently, this action expects a flat repo structure with exactly one complete mod in the git repo (with a valid info.json in the repo's root).

It also expects tag names to match the Factorio mod version numbering scheme - three numbers separated by periods, eg. `1.15.0`.

Non-tag pushes will be ignored, but when a tag is pushed that is valid and matches the version number in info.json, the mod will be zipped up and published to the mod portal using the required secrets `FACTORIO_USER` and `FACTORIO_PASSWORD` to authenticate.

An example workflow to publish tagged releases:

    workflow "Publish mod to portal" {
      on = "push"
      resolves = ["shanemadden/factorio-mod-portal-publish@stable"]
    }

    action "shanemadden/factorio-mod-portal-publish@stable" {
      uses = "shanemadden/factorio-mod-portal-publish@stable"
      secrets = ["FACTORIO_USER", "FACTORIO_PASSWORD"]
    }

`FACTORIO_USER` and `FACTORIO_PASSWORD` secrets should be valid credentials to the Factorio mod portal with permissions to edit the mod defined in info.json.

Be aware that the zip will be published and immediately available for download for users - make sure you're ready to publish the changes and have tested the commit before pushing the tag!
