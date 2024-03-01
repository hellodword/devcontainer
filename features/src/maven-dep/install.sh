#!/bin/bash
set -e
set +H
set -x

# check java version and mvn
[ -n "$JAVA_HOME" ]
[ "$(javac --version | grep -oP '(?<=javac\s)\d+')" = "17" ]
mvn --version

# export MVN="$(which mvn | head -1)"

# sudo -Eu "$_REMOTE_USER" bash -ex << EOF
# # fix HOME rewrited by sudo -E
# export HOME="$_REMOTE_USER_HOME"

# "$MVN" --version

# # Options.
# [ -n "$GIT" ]

# if [ -n "$BRANCH" ]; then
#     git clone --depth 1 "$GIT" -b "$BRANCH" /tmp/gitrepo
# else
#     git clone --depth 1 "$GIT" /tmp/gitrepo
# fi

# pushd /tmp/gitrepo

# "$MVN" clean install -Dgpg.skip=true

# popd
# rm -rf /tmp/gitrepo

# EOF


# Options.
[ -n "$GIT" ]

if [ -n "$BRANCH" ]; then
    git clone --depth 1 "$GIT" -b "$BRANCH" /tmp/gitrepo
else
    git clone --depth 1 "$GIT" /tmp/gitrepo
fi

pushd /tmp/gitrepo

mvn -Dmaven.repo.local=$_REMOTE_USER_HOME/.m2/repository clean install -Dgpg.skip=true

popd
rm -rf /tmp/gitrepo

sudo chown -R "$_REMOTE_USER:$_REMOTE_USER" "$_REMOTE_USER_HOME/.m2"
