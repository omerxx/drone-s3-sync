#!/bin/bash

if [ -z ${PLUGIN_BUCKET} ]; then
  echo "missing S3 Bucket"
  exit 1
fi

if [ -z ${PLUGIN_REGION} ]; then
  PLUGIN_REGION="us-east-1"
fi

if [ -z ${PLUGIN_BUCKET} ]; then
  PLUGIN_BUCKET="300"
fi

if [ -z ${PLUGIN_TARGET} ]; then
  PLUGIN_TARGET="/"
fi

if [ -z ${PLUGIN_SOURCE} ]; then
  PLUGIN_SOURCE="./"
fi

if [ ${PLUGIN_DELETE} == true ]; then
  PLUGIN_DELETE="--delete"
else
  PLUGIN_DELETE=""
fi

if [ ! -z ${PLUGIN_AWS_ACCESS_KEY_ID} ]; then
  AWS_ACCESS_KEY_ID=$PLUGIN_AWS_ACCESS_KEY_ID
fi

if [ ! -z ${PLUGIN_AWS_SECRET_ACCESS_KEY} ]; then
  AWS_SECRET_ACCESS_KEY=$PLUGIN_AWS_SECRET_ACCESS_KEY
fi

aws s3 sync --region $PLUGIN_REGION $PLUGIN_DELETE $PLUGIN_SOURCE s3://$PLUGIN_BUCKET/$PLUGIN_TARGET


if [ -n "$PLUGIN_CLOUDFRONT_DISTRIBUTION_ID" ]; then
  aws cloudfront create-invalidation --region $PLUGIN_REGION --distribution-id $PLUGIN_CLOUDFRONT_DISTRIBUTION_ID --paths /*
fi

