#!/bin/sh

set -e
set -u

xargs npm install --global < ./npm-global-list
