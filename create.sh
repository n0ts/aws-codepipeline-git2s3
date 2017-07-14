#!/bin/bash

set -e -o pipefail

if [[ -z "$1" ]]; then
    echo "Usage: create.sh <BUCKET>"
    exit 1
fi

readonly name=Git2CodePipeline
readonly bucket=$1

set +e
aws s3 ls s3://$bucket
if [[ $? -ne 0 ]]; then
    aws s3 mb s3://$bucket
fi
set -e

aws s3 cp --acl public-read git2s3.template s3://$bucket/

readonly lambda=(
    CreateSSHKey
    DeleteBucketContents
    GitPull
    ZipDl
)

for i in "${lambda[@]}"; do
    if [[ -f "$i.zip" ]]; then
        cp -v $i.zip .$i.zip
    fi

    if [[ -f "$i/lambda_function.py" ]]; then
        zip -jrv .$i.zip $i/ "*/lambda_function.py"
    fi

    aws s3 cp --acl public-read .$i.zip s3://$bucket/$i.zip
done
rm -vf .*.zip

aws cloudformation create-stack \
    --capabilities CAPABILITY_IAM \
    --stack-name $name \
    --template-url https://s3.amazonaws.com/$bucket/git2s3.template \
    --parameters "ParameterKey=LambdaBucket,ParameterValue=$bucket" \
    --tags "Key=Name,Value=$name"
