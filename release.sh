#!/bin/sh
: ${1?"Usage: $0 <version>"}

mvn -B versions:set -DnewVersion=${1} -DgenerateBackupPoms=false
git add .
git commit -m "Release version ${1}"
mvn -B -e -T4 clean install
mvn -B -Prelease -e deploy -Dmaven.test.skip=true
git tag -a v${1} -m "Tag for release ${1}"
git push origin master
git push origin --tags