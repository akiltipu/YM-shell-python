import boto3
from botocore.exceptions import ClientError

class S3Manager:
    def __init__(self):
        self.s3 = boto3.client('s3')
    
    def create_bucket(self, bucket_name, region='us-east-1'):
        try:
            if region == 'us-east-1':
                self.s3.create_bucket(Bucket=bucket_name)
            else:
                self.s3.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': region}
                )
            print(f"✓ Bucket '{bucket_name}' created")
            return True
        except ClientError as e:
            print(f"✗ Error: {e}")
            return False
    
    def upload_file(self, file_path, bucket_name, object_name=None):
        if object_name is None:
            object_name = file_path
        
        try:
            self.s3.upload_file(file_path, bucket_name, object_name)
            print(f"✓ Uploaded '{file_path}' to '{bucket_name}/{object_name}'")
            return True
        except ClientError as e:
            print(f"✗ Error: {e}")
            return False
    
    def download_file(self, bucket_name, object_name, file_path):
        try:
            self.s3.download_file(bucket_name, object_name, file_path)
            print(f"✓ Downloaded '{object_name}' to '{file_path}'")
            return True
        except ClientError as e:
            print(f"✗ Error: {e}")
            return False
    
    def list_files(self, bucket_name):
        try:
            response = self.s3.list_objects_v2(Bucket=bucket_name)
            if 'Contents' in response:
                print(f"\nFiles in '{bucket_name}':")
                for obj in response['Contents']:
                    print(f"  - {obj['Key']} ({obj['Size']} bytes)")
                return response['Contents']
            else:
                print(f"Bucket '{bucket_name}' is empty")
                return []
        except ClientError as e:
            print(f"✗ Error: {e}")
            return []
    
    def delete_file(self, bucket_name, object_name):
        try:
            self.s3.delete_object(Bucket=bucket_name, Key=object_name)
            print(f"✓ Deleted '{object_name}' from '{bucket_name}'")
            return True
        except ClientError as e:
            print(f"✗ Error: {e}")
            return False

# Demo usage
manager = S3Manager()

bucket_name = 'my-demo-bucket-xyz123'

# Create bucket
manager.create_bucket(bucket_name)

# Create and upload a file
with open('test.txt', 'w') as f:
    f.write("Hello AWS S3 from Python!")

manager.upload_file('test.txt', bucket_name, 'documents/test.txt')

# List files
manager.list_files(bucket_name)

# Download file
manager.download_file(bucket_name, 'documents/test.txt', 'downloaded.txt')

# Delete file
manager.delete_file(bucket_name, 'documents/test.txt')