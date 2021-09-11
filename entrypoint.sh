#!/bin/sh -l

git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git pull github ${GITHUB_REF} --ff-only

sudo xcode-select --s /Applications/Xcode_13.0.app

# Build DocC and dump it in a temporary build directory
output="$( bash <<EOF
sh build.sh
EOF
)"

echo "$output"

if [[ $output == *"BUILD DOCUMENTATION SUCCEEDED"* ]]; then
    cd Web/
    npm install

else
    echo "Build Failed"
    exit 1
fi