#!/bin/sh -l

git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git pull github ${GITHUB_REF} --ff-only

cd $0

sudo xcode-select --s /Applications/Xcode_13.0.app

# Build DocC and dump it in a temporary build directory
output="$( bash <<EOF
xcodebuild docbuild -scheme $0 -derivedDataPath tmp/
EOF
)"

echo "$output"

if [[ $output == *"BUILD DOCUMENTATION SUCCEEDED"* ]]; then
    # Remove the old DocC from web
    rm -rf $1

    # Move the doccarchive to the Web folder, rename it to public
    mv tmp/Build/Products/Debug/$0.doccarchive/ $1

    # Delete temporary build directory
    rm -rf tmp

    git add .

    git commit -m "Compiled DocC for Web"
    git push github HEAD:${GITHUB_REF}
else
    echo "Build Failed"
    exit 1
fi