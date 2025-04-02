import json
import requests
import boto3
from datetime import datetime

def lambda_handler(event, context):
    try:
        # Make a request to a public API (using JSONPlaceholder as an example)
        response = requests.get('https://jsonplaceholder.typicode.com/posts/1')
        data = response.json()
        
        # Create S3 client with internal LocalStack endpoint
        s3 = boto3.client('s3', endpoint_url='http://localhost.localstack.cloud:4566')
        
        # Generate a unique filename using timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f'response_{timestamp}.json'
        
        print(f"Attempting to write to S3 bucket: test-bucket, key: {filename}")  # Add logging
        
        # Write the response to S3
        s3.put_object(
            Bucket='test-bucket',
            Key=filename,
            Body=json.dumps(data, indent=2)
        )
        
        print("Successfully wrote to S3")  # Add logging
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Successfully fetched data and saved to S3',
                'data': data,
                's3_file': filename
            })
        }
    except Exception as e:
        print(f"Error: {str(e)}")  # Add logging
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error occurred',
                'error': str(e)
            })
        } 