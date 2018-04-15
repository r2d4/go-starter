#!/bin/bash

NEW_PROJECT=$1
COMPANY=$2

CURRENT_ORG=$(realpath --relative-to=$GOPATH/src $PWD)
OLD_ORG=github.com/r2d4/go-starter
OLD_PROJECT=go-starter

mv cmd/$OLD_PROJECT cmd/$NEW_PROJECT
mv pkg/$OLD_PROJECT pkg/$NEW_PROJECT

find . -name $OLD_PROJECT.go -type f | sed -e "p;s/$OLD_PROJECT/$NEW_PROJECT/" | xargs -n2 mv



# find . -name $OLD_PROJECT -type d | sed -e "p;s/$OLD_PROJECT/$NEW_PROJECT/" | xargs -n2 mv

find . -type f ! -name rename.sh -exec \
    sed -i 's/COMPANY LLC/$COMPANY/g' {} +

find . -type f ! -name rename.sh -exec \
    sed -i 's/$OLD_PROJECT/$NEW_PROJECT/g' {} +

go get github.com/r2d4/fiximports

fiximports -new-import '$(CURRENT_ORG)$1' -old-import '$(OLD_ORG)' -regex .
fiximports -new-import '$(CURRENT_ORG)/cmd/$1' -old-import '$OLD_ORG/cmd' -regex .
fiximports -new-import '$(CURRENT_ORG)/pkg/$1' -old-import '$OLD_ORG/pkg' -regex .

find . -type f ! -name rename.sh -exec \
    sed -i 's/$OLD_ORG/$NEW_ORG/g' {} +
