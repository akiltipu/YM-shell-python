import boto3

s3 = boto3.client('s3')

bucket_name = 'akiltipu-devops-bucket-123456'
object_name = 'uploaded_log.txt'
download_path = 'downloaded_log.txt'

try:
    s3.download_file(bucket_name, object_name, download_path)
    print(f"File downloaded to '{download_path}'")
    
    # Read and display the content
    with open(download_path, 'r') as f:
        print("\nFile Content:")
        print(f.read())
except Exception as e:
    print(f"Error: {e}")