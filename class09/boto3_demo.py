# installing the boto3 package
# pip install boto3
# You may need to configure your AWS credentials for boto3 to work properly.
# configuring AWS credentials can be done using the AWS CLI or by setting environment variables.
# aws configure
# Example of setting environment variables:
# export AWS_ACCESS_KEY_ID='your_access_key_id'
# export AWS_SECRET_ACCESS_KEY='your_secret_access_key'
# export AWS_DEFAULT_REGION='your_preferred_region'
# Once configured, you can use boto3 to interact with AWS services.

import boto3

s3 = boto3.client('s3')

bucket_name = 'akiltipu-devops-bucket-123456'

try:
    s3.create_bucket(Bucket=bucket_name)
    print(f'Bucket {bucket_name} created successfully.')
except Exception as e:
    print(f'Error creating bucket: {e}')


