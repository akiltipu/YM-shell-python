import boto3

s3 = boto3.client('s3')

# List all buckets
print("Your S3 Buckets:")
print("-" * 40)
response = s3.list_buckets()

for bucket in response['Buckets']:
    print(f"  - {bucket['Name']}")

# List objects in a specific bucket
bucket_name = 'akiltipu-devops-bucket-123456'
print(f"\nFiles in '{bucket_name}':")
print("-" * 40)

response = s3.list_objects_v2(Bucket=bucket_name)

if 'Contents' in response:
    for obj in response['Contents']:
        print(f"  - {obj['Key']} (Size: {obj['Size']} bytes)")
else:
    print("  No files found")