#!/bin/bash

git add .

echo -n "enter git message:" ---：
read msg
if [ -z $msg ]; then
  msg="upd: update docs"
fi
git commit -m"$msg"
git pull -r
git push origin main
