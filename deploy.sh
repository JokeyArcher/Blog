#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
hugo -D

# 进入生成的文件夹
cd public

git init -b pages
git add -A
git commit -m 'deploy'

# 如果发布到 https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:Kycer/kycer.github.io.git pages

cd -

rm -rf public