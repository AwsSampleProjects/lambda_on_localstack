# Prepare lambda function ZIP

mkdir -p lambda_package && cd lambda_package && python3.9 -m pip install -r ../test_lambda/requirements.txt -t . && cp ../test_lambda/lambda_function.py . && zip -r ../function.zip . && cd .. && rm -rf lambda_package

# Install lambda function

awslocal iam create-role --role-name lambda-role --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
# awslocal lambda delete-function --profile localstack --function-name test-function
awslocal lambda create-function --function-name test-function --runtime python3.9 --handler lambda_function.lambda_handler --zip-file fileb://function.zip --role arn:aws:iam::000000000000:role/lambda-role
# awslocal lambda list-functions --profile localstack
awslocal lambda invoke --function-name test-function --payload '{}' response.json

# Create SQS queue

awslocal sqs create-queue --queue-name test-queue

awslocal iam create-policy --policy-name lambda-sqs-policy --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"],"Resource":"arn:aws:sqs:eu-central-1:000000000000:test-queue"}]}'
awslocal iam attach-role-policy --role-name lambda-role --policy-arn arn:aws:iam::000000000000:policy/lambda-sqs-policy
awslocal lambda create-event-source-mapping --function-name test-function --event-source-arn arn:aws:sqs:eu-central-1:000000000000:test-queue --batch-size 1

# Create S3

awslocal s3 mb s3://test-bucket

# Policy for writing to S3
awslocal iam create-policy --policy-name lambda-s3-policy --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["s3:PutObject"],"Resource":"arn:aws:s3:::test-bucket/*"}]}'
awslocal iam attach-role-policy --role-name lambda-role --policy-arn arn:aws:iam::000000000000:policy/lambda-s3-policy

# Invoke SQS

awslocal sqs send-message --queue-url http://localhost:4566/000000000000/test-queue --message-body '{"test": "message"}'

# Check logs

awslocal logs tail /aws/lambda/test-function

# Check bucket

awslocal s3 ls s3://test-bucket/

# Check content of the file

awslocal s3 cp s3://test-bucket/response_20250402_212645.json - | cat