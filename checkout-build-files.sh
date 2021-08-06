#!/bin/bash

git status|grep tar.gz|cut -d ' ' -f4|xargs git checkout
git status|grep version|cut -d ' ' -f4|xargs git checkout
git status|grep config.json.js|cut -d ' ' -f4|xargs git checkout
