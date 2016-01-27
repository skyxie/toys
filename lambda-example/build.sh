#! /bin/sh

rm lambda-test.zip
zip -r lambda-test.zip index.js package.json node_modules --exclude=node_modules/aws-sdk/*
aws lambda update-function-code --function-name tian-images-128x128 --zip-file fileb://lambda-test.zip