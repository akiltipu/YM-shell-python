import boto3

s3 = boto3.client('s3')
bucket_name = 'akiltipu-devops-bucket-123456'

file_name = 'log.txt'
object_name = 'uploaded_log.txt'

try:
    with open(file_name, 'w') as file_data:
        file_data.write('This is a sample log file for upload to S3.\n')
    s3.upload_file(file_name, bucket_name, object_name)
    print(f'File {file_name} uploaded to bucket {bucket_name} as {object_name}.')
except Exception as e:
    print(f'Error uploading file: {e}')