#! /bin/bash
# 使用方式
# syc.sh -m "args"
hugo
cd public
git add .
git commit -m "$2"
git push
