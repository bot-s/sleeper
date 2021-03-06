#!/bin/sh

# Required environment variables
# GIT_URL: target github ssh url
GIT_BRANCH_NAME="circleci/update-history"
GITHUB_FILE="github_secret";
HISTORY_FILENAME="history"
HISTORY_PATH=$PWD/$HISTORY_FILENAME

# setup hub
which node
which go
which ruby
node -v
npm -v
go version
ruby -v

sudo ln -s /usr/local/go/bin/go /usr/bin/go
sudo which go

git clone https://github.com/github/hub.git
cd hub
git fetch --tags
git checkout -b v2.2.9
sudo make install
ls -a
which hub

cd ..

# setup git
echo $GITHUB_SECRET > $HISTORY_PATH
export GIT_SSH_COMMAND="ssh -i $HISTORY_PATH"

# create commit
echo "Adding history... $1"
echo $1 >> $HISTORY_PATH

hub config user.email $GITHUB_EMAIL
hub config user.name $GITHUB_NAME
hub add .
hub commit -m 'Update history'
hub fork
hub push $GITHUB_NAME $GIT_BRANCH_NAME
hub pull-request
