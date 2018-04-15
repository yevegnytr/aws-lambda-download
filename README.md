# aws-lambda-download
A simple bash script to archive your AWS Lambda functions locally.

## Requirements
1. AWS CLI installed.
2. Authentication to your AWS account via AWS CLI.

## Usage
Run the script and it will enum the Lambda functions in your region then download the source code in zip files, rename the files to a proper name and then download their metadata manifests.
