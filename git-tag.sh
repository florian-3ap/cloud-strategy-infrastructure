#!/bin/bash

git tag --delete provision-cloud
git push origin :refs/tags/provision-cloud

git tag provision-cloud
git push origin provision-cloud
