# Manual

### Check python
`python3.9 --version`

### Install AWS CLI
### Install docker
### Install AWS Local
`pip install awscli-local `
### Set up CLI credentials

configuration for profile `localstack`
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
    ```