#!/bin/bash
# A simple bash script to archive your AWS Lambda functions locally.
# Created by Yevgeny Trachtinov
# Feel free to adjust your download locations and settings or drop me a suggestion via jendoz@gmail.com

echo "Getting all function names"
aws lambda list-functions | jq -r '.Functions [] | .FunctionName' > function-names.txt

echo "Getting download URLs..."
for i in `cat function-names.txt`
  do
    aws lambda get-function --function-name "$i" \
    | jq -r '.Code | .Location' > lambda_func_urls.txt
done

echo "Starting to download functions..."
if [ ! -d functions ];
  then
    mkdir functions
  else
    echo "function dir exist"
fi

pushd functions
wget --content-disposition --trust-server-names --quiet -i ../lambda_func_urls.txt

# This should be fixed on wget level, but I couldn't found how...
echo "Renaming downloaded files to correct name"
for i in `ls -1`;
  do target=$(echo $i | sed 's/\?.*/.zip/g')
  mv "$i" "$target"
done
popd

echo "Getting function configurations..."
if [ ! -d manifests ];
  then
    mkdir manifests
  else
    echo "manifests dir exist"
fi

pushd manifests
for i in `cat ../function-names.txt`
  do
    aws lambda get-function-configuration --function-name "$i" > $i.json
done
popd

# Cleanup
rm lambda_func_urls.txt function-names.txt
