# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=ppouliot
# image name
IMAGE=puppet-maas

# Ensure the repo is up to date
git pull

# Bump Version
docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=`cat VERSION`
set -x
echo "version: $VERSION"
# Bump Version in metadata.json
sed -i '' 's/^.*\"version\"\:.*/\"version\"\:\ \"'"$VERSION"'\",/' metadata.json

# run build

./build.sh -v
# tag it
git add -A
git commit -m "version $VERSION"
git tag -a "$VERSION" -m "version $VERSION"
git push
git push --tags
#docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version
#docker tag $USERNAME/$IMAGE-ubuntu:latest $USERNAME/$IMAGE-ubuntu:$version
# push it
#docker push $USERNAME/$IMAGE
