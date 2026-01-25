import boto3

s3 = boto3.client('s3')

bucket_name = 'akiltipu-devops-bucket-123456'
object_name = 'uploaded_log.txt'

# Delete a file (object)
try:
    s3.delete_object(Bucket=bucket_name, Key=object_name)
    print(f"Deleted '{object_name}' from '{bucket_name}'")
except Exception as e:
    print(f"Error: {e}")

# Delete a bucket (must be empty first)
try:
    s3.delete_bucket(Bucket=bucket_name)
    print(f"Bucket '{bucket_name}' deleted")
except Exception as e:
    print(f"Error: {e}")