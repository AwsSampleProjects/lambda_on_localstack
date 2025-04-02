![image](https://github.com/user-attachments/assets/5d828009-e3a0-4133-b634-388208f2b36d)

# Manual

### Install SAM CLI

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html

AWS: Detect SAM CLI

In case of problems with docker do this: https://stackoverflow.com/a/77926411/1816687

### Install AWS Toolkit VSCode extension

Edit AWS CLI credentials and configuration

Edit files:
- `~/.aws/config` - for configuration
- `~/.aws/credentials` - for credentials

Add new profile if needed e.g. localstack:

Config
configuration for profile `profile localstack`
```
[profile localstack]
region = eu-central-1
output = json
s3 =
    endpoint_url = http://localhost:4566
lambda =
    endpoint_url = http://localhost:4566
iam =
    endpoint_url = http://localhost:4566
logs =
    endpoint_url = http://localhost:4566
sqs =
    endpoint_url = http://localhost:4566
```

### Check python
`python3.9 --version`

### Install AWS Local
`pip install awscli-local `
