#!/bin/bash

# Parse the tag we're on, do nothing if there isn't one
TAG=$(echo ${GITHUB_REF} | grep tags | grep -o "[^/]*$")
if [[ -z "${TAG}" ]]; then
    echo "Not a tag push, skipping"
    exit 78
fi

# Validate the version string we're building
if ! echo "${TAG}" | grep -P --quiet '^\d+\.\d+\.\d+$'; then
    echo "Bad version, needs to be %u.%u.%u."
    exit 1
fi

INFO_VERSION=$(jq '.version' info.json)
# Make sure the info.json is parseable and has the expected version number
if [[ "${INFO_VERSION}" -ne "${TAG}" ]]; then
    echo "Tag version doesn't match info.json (or info.json is invalid), failed"
    exit 1
fi
# Create the zip
mkdir /tmp/zip
ln -s /github/workspace "/tmp/zip/$1_${TAG}"
zip -q -r "$1_${TAG}.zip" "/tmp/zip/$1_${TAG}" -x \*.git\*
FILESIZE=$(stat --printf="%s" "$1_${TAG}.zip")
echo "File zipped, ${FILESIZE} bytes"
unzip -l "$1_${TAG}.zip"

# Get a CSRF token by loading the login form
CSRF=$(curl -b cookiejar.txt -c cookiejar.txt -s https://mods.factorio.com/login | grep csrf_token | sed -r -e 's/.*value="(.*)".*/\1/')

# Authenticate with the credential secrets and the CSRF token, getting a session cookie for the authorized user
curl -b cookiejar.txt -c cookiejar.txt -s -F "csrf_token=${CSRF}" -F "username=${FACTORIO_USER}" -F "password=${FACTORIO_PASSWORD}" -o /dev/null https://mods.factorio.com/login

# Query the mod info, verify the version number we're trying to push doesn't already exist
curl -b cookiejar.txt -c cookiejar.txt -s https://mods.factorio.com/api/mods/$1/full | jq -e ".releases[] | select(.version == \"${TAG}\")"
# store the return code before running anything else
STATUS_CODE=$?

if [[ $STATUS_CODE -ne 4 ]]; then
    echo "Release already exists, skipping"
    exit 78
fi
echo "Release doesn't exist for ${TAG}, uploading"

# Load the upload form, getting an upload token
UPLOAD_TOKEN=$(curl -b cookiejar.txt -c cookiejar.txt -s https://mods.factorio.com/mod/$1/downloads/edit | grep token | sed -r -e "s/.*token: '(.*)'.*/\1/")
if [[ -z "${UPLOAD_TOKEN}" ]]; then
    echo "Couldn't get an upload token, failed"
    exit 1
fi

# Upload the file, getting back a response with details to send in the final form submission to complete the upload
UPLOAD_RESULT=$(curl -b cookiejar.txt -c cookiejar.txt -s -F "file=@$1_${TAG}.zip;type=application/x-zip-compressed" "https://direct.mods-data.factorio.com/upload/mod/${UPLOAD_TOKEN}")
echo "result: ${UPLOAD_RESULT}"

# Parse 'em and stat the file for the form fields
CHANGELOG=$(echo ${UPLOAD_RESULT} | jq -r '.changelog' | tr " " "+" | tr -d "\r\n" | tr -d "\t")
INFO=$(echo ${UPLOAD_RESULT} | jq -r '.info' | tr " " "+" | tr -d "\r\n" | tr -d "\t")
FILENAME=$(echo ${UPLOAD_RESULT} | jq -r '.filename')

if [[ "${FILENAME}" -eq "null" ]] || [[ -z "${FILENAME}" ]]; then
    echo "Upload failed"
    exit 1
fi
echo "Uploaded $1_${TAG}.zip to ${FILENAME}, submitting"
echo "file=&info_json=${INFO}&changelog=${CHANGELOG}&filename=${FILENAME}&file_size=${FILESIZE}"

# Post the form, completing the release
curl -b cookiejar.txt -c cookiejar.txt -s -X POST -d "file=&info_json=${INFO}&changelog=${CHANGELOG}&filename=${FILENAME}&file_size=${FILESIZE}" -H "Content-Type: application/x-www-form-urlencoded" -o /dev/null https://mods.factorio.com/mod/$1/downloads/edit

echo "Completed"
