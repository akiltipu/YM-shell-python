#!/usr/bin/env python3
"""
AWS Serverless Infrastructure Setup
Creates and manages AWS infrastructure for Lambda + SNS + S3 logging
Beginner-friendly script with detailed comments
"""

import boto3
import json
import zipfile
import os
import time
from datetime import datetime

class ServerlessInfrastructure:
    """Manages AWS serverless infrastructure setup"""
    
    def __init__(self, region='us-east-1'):
        """
        Initialize AWS clients
        
        Args:
            region: AWS region to deploy resources (default: us-east-1)
        """
        self.region = region
        self.iam = boto3.client('iam', region_name=region)
        self.lambda_client = boto3.client('lambda', region_name=region)
        self.sns = boto3.client('sns', region_name=region)
        self.s3 = boto3.client('s3', region_name=region)
        self.logs = boto3.client('logs', region_name=region)
        
        # Resource names
        self.bucket_name = f'serverless-logs-{int(time.time())}'
        self.topic_name = 'lambda-notifications-topic'
        self.function_name = 'notification-sender-function'
        self.role_name = 'lambda-sns-s3-role'
        
        print(f"AWS clients initialized for region: {region}")
    
    def create_s3_bucket(self):
        """Create S3 bucket for storing Lambda logs"""
        try:
            print(f"\n Creating S3 bucket: {self.bucket_name}")
            
            # Create bucket (different API call for us-east-1)
            if self.region == 'us-east-1':
                self.s3.create_bucket(Bucket=self.bucket_name)
            else:
                self.s3.create_bucket(
                    Bucket=self.bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': self.region}
                )
            
            # Enable versioning
            self.s3.put_bucket_versioning(
                Bucket=self.bucket_name,
                VersioningConfiguration={'Status': 'Enabled'}
            )
            
            # Add tags
            self.s3.put_bucket_tagging(
                Bucket=self.bucket_name,
                Tagging={
                    'TagSet': [
                        {'Key': 'Purpose', 'Value': 'Lambda Logs'},
                        {'Key': 'CreatedBy', 'Value': 'ServerlessDemo'}
                    ]
                }
            )
            
            print(f"✓ S3 bucket created: {self.bucket_name}")
            return self.bucket_name
            
        except self.s3.exceptions.BucketAlreadyExists:
            print(f"⚠ Bucket already exists: {self.bucket_name}")
            return self.bucket_name
        except Exception as e:
            print(f"✗ Error creating S3 bucket: {e}")
            raise
    
    def create_sns_topic(self):
        """Create SNS topic for notifications"""
        try:
            print(f"\n Creating SNS topic: {self.topic_name}")
            
            response = self.sns.create_topic(Name=self.topic_name)
            topic_arn = response['TopicArn']
            
            # Add tags
            self.sns.tag_resource(
                ResourceArn=topic_arn,
                Tags=[
                    {'Key': 'Purpose', 'Value': 'Lambda Notifications'},
                    {'Key': 'CreatedBy', 'Value': 'ServerlessDemo'}
                ]
            )
            
            print(f"✓ SNS topic created: {topic_arn}")
            return topic_arn
            
        except Exception as e:
            print(f"✗ Error creating SNS topic: {e}")
            raise
    
    def subscribe_email_to_sns(self, topic_arn, email):
        """
        Subscribe an email address to SNS topic
        
        Args:
            topic_arn: ARN of the SNS topic
            email: Email address to subscribe
        """
        try:
            print(f"\n Subscribing email to SNS: {email}")
            
            response = self.sns.subscribe(
                TopicArn=topic_arn,
                Protocol='email',
                Endpoint=email
            )
            
            print(f"Subscription created (check email to confirm): {response['SubscriptionArn']}")
            print("You must confirm the subscription via email!")
            return response['SubscriptionArn']
            
        except Exception as e:
            print(f"✗ Error subscribing email: {e}")
            raise
    
    def create_iam_role(self):
        """Create IAM role for Lambda with SNS, S3, and CloudWatch permissions"""
        try:
            print(f"\n Creating IAM role: {self.role_name}")
            
            # Trust policy - allows Lambda to assume this role
            trust_policy = {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Principal": {"Service": "lambda.amazonaws.com"},
                        "Action": "sts:AssumeRole"
                    }
                ]
            }
            
            # Create role
            try:
                response = self.iam.create_role(
                    RoleName=self.role_name,
                    AssumeRolePolicyDocument=json.dumps(trust_policy),
                    Description='Role for Lambda to access SNS, S3, and CloudWatch'
                )
                role_arn = response['Role']['Arn']
                print(f"✓ IAM role created: {role_arn}")
            except self.iam.exceptions.EntityAlreadyExistsException:
                print(f"⚠ Role already exists, getting ARN...")
                response = self.iam.get_role(RoleName=self.role_name)
                role_arn = response['Role']['Arn']
            
            # Attach managed policies
            policies = [
                'arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole',  # CloudWatch Logs
                'arn:aws:iam::aws:policy/AmazonSNSFullAccess',  # SNS
                'arn:aws:iam::aws:policy/AmazonS3FullAccess'  # S3
            ]
            
            for policy_arn in policies:
                try:
                    self.iam.attach_role_policy(
                        RoleName=self.role_name,
                        PolicyArn=policy_arn
                    )
                    print(f"✓ Attached policy: {policy_arn.split('/')[-1]}")
                except Exception as e:
                    print(f"⚠ Policy already attached or error: {e}")
            
            # Wait for role to be available
            print("⏳ Waiting for IAM role to propagate (10 seconds)...")
            time.sleep(10)
            
            return role_arn
            
        except Exception as e:
            print(f"✗ Error creating IAM role: {e}")
            raise
    
    def package_lambda_code(self):
        """Package Lambda function code into a zip file"""
        try:
            print("\n Packaging Lambda code...")
            
            zip_file = 'lambda_function.zip'
            lambda_file = 'lambda/index.py'
            
            # Check if lambda file exists
            if not os.path.exists(lambda_file):
                raise FileNotFoundError(f"Lambda file not found: {lambda_file}")
            
            # Create zip file
            with zipfile.ZipFile(zip_file, 'w', zipfile.ZIP_DEFLATED) as zipf:
                zipf.write(lambda_file, 'index.py')
            
            print(f"✓ Lambda code packaged: {zip_file}")
            return zip_file
            
        except Exception as e:
            print(f"✗ Error packaging Lambda code: {e}")
            raise
    
    def create_lambda_function(self, role_arn, topic_arn):
        """
        Create Lambda function
        
        Args:
            role_arn: ARN of the IAM role
            topic_arn: ARN of the SNS topic
        """
        try:
            print(f"\n Creating Lambda function: {self.function_name}")
            
            # Package code
            zip_file = self.package_lambda_code()
            
            # Read zip file
            with open(zip_file, 'rb') as f:
                zip_content = f.read()
            
            # Create Lambda function
            try:
                response = self.lambda_client.create_function(
                    FunctionName=self.function_name,
                    Runtime='python3.9',
                    Role=role_arn,
                    Handler='index.lambda_handler',
                    Code={'ZipFile': zip_content},
                    Description='Sends notifications through SNS',
                    Timeout=30,
                    MemorySize=128,
                    Environment={
                        'Variables': {
                            'SNS_TOPIC_ARN': topic_arn,
                            'LOG_BUCKET': self.bucket_name
                        }
                    },
                    Tags={
                        'Purpose': 'Notification Sender',
                        'CreatedBy': 'ServerlessDemo'
                    }
                )
                
                function_arn = response['FunctionArn']
                print(f"✓ Lambda function created: {function_arn}")
                
            except self.lambda_client.exceptions.ResourceConflictException:
                print(f"⚠ Function already exists, updating code...")
                response = self.lambda_client.update_function_code(
                    FunctionName=self.function_name,
                    ZipFile=zip_content
                )
                
                # Update environment variables
                self.lambda_client.update_function_configuration(
                    FunctionName=self.function_name,
                    Environment={
                        'Variables': {
                            'SNS_TOPIC_ARN': topic_arn,
                            'LOG_BUCKET': self.bucket_name
                        }
                    }
                )
                
                function_arn = response['FunctionArn']
                print(f"✓ Lambda function updated: {function_arn}")
            
            # Clean up zip file
            os.remove(zip_file)
            
            return function_arn
            
        except Exception as e:
            print(f"✗ Error creating Lambda function: {e}")
            raise
    
    def test_lambda_function(self):
        """Test the Lambda function"""
        try:
            print(f"\n Testing Lambda function: {self.function_name}")
            
            # Wait for Lambda to be active
            print("⏳ Waiting for Lambda function to be active...")
            max_wait = 30  # seconds
            wait_interval = 2  # seconds
            waited = 0
            
            while waited < max_wait:
                try:
                    func_config = self.lambda_client.get_function(FunctionName=self.function_name)
                    state = func_config['Configuration']['State']
                    
                    if state == 'Active':
                        print(f"✓ Lambda function is active!")
                        break
                    elif state in ['Failed', 'Inactive']:
                        print(f"⚠ Lambda function is in {state} state")
                        return None
                    else:
                        print(f"  Still waiting... (state: {state})")
                        time.sleep(wait_interval)
                        waited += wait_interval
                except Exception as e:
                    print(f"  Checking status... ({waited}s)")
                    time.sleep(wait_interval)
                    waited += wait_interval
            
            if waited >= max_wait:
                print(f"⚠ Lambda function did not become active within {max_wait} seconds")
                print("  You can test it manually later using AWS Console or AWS CLI")
                return None
            
            # Test payload
            test_event = {
                'message': 'Hello from infrastructure setup!',
                'subject': 'Test Notification',
                'timestamp': datetime.now().isoformat()
            }
            
            # Invoke Lambda
            response = self.lambda_client.invoke(
                FunctionName=self.function_name,
                InvocationType='RequestResponse',
                Payload=json.dumps(test_event)
            )
            
            # Parse response
            result = json.loads(response['Payload'].read())
            
            if response['StatusCode'] == 200:
                print(f"✓ Lambda test successful!")
                print(f"  Response: {json.dumps(result, indent=2)}")
            else:
                print(f"⚠ Lambda test returned status: {response['StatusCode']}")
                print(f"  Response: {result}")
            
            return result
            
        except Exception as e:
            print(f"✗ Error testing Lambda function: {e}")
            print("⚠ Test failed, but infrastructure is deployed. You can test manually later.")
            return None
    
    def export_logs_to_s3(self, log_group_name):
        """
        Export CloudWatch logs to S3
        
        Args:
            log_group_name: Name of the CloudWatch log group
        """
        try:
            print(f"\n Exporting logs to S3...")
            
            # Create export task
            timestamp = int(time.time() * 1000)
            
            response = self.logs.create_export_task(
                logGroupName=log_group_name,
                fromTime=timestamp - 3600000,  # Last hour
                to=timestamp,
                destination=self.bucket_name,
                destinationPrefix='lambda-logs'
            )
            
            task_id = response['taskId']
            print(f"✓ Log export task created: {task_id}")
            print(f"  Logs will be exported to: s3://{self.bucket_name}/lambda-logs/")
            
            return task_id
            
        except Exception as e:
            print(f"⚠ Error exporting logs (may need to wait for logs to be generated): {e}")
            return None
    
    def deploy_infrastructure(self, email=None):
        """
        Deploy complete serverless infrastructure
        
        Args:
            email: Optional email address to subscribe to SNS notifications
        """
        print("\n" + "="*60)
        print("🚀 DEPLOYING SERVERLESS INFRASTRUCTURE")
        print("="*60)
        
        try:
            # Step 1: Create S3 bucket for logs
            bucket_name = self.create_s3_bucket()
            
            # Step 2: Create SNS topic
            topic_arn = self.create_sns_topic()
            
            # Step 3: Subscribe email if provided
            if email:
                self.subscribe_email_to_sns(topic_arn, email)
            
            # Step 4: Create IAM role
            role_arn = self.create_iam_role()
            
            # Step 5: Create Lambda function
            function_arn = self.create_lambda_function(role_arn, topic_arn)
            
            # Step 6: Test Lambda function (optional, may skip if not ready)
            test_result = self.test_lambda_function()
            
            # Step 7: Setup log export (optional)
            log_group_name = f'/aws/lambda/{self.function_name}'
            print(f"\n📊 CloudWatch logs available at: {log_group_name}")
            
            # Print summary
            print("\n" + "="*60)
            print("✅ DEPLOYMENT COMPLETE!")
            print("="*60)
            print(f"\n S3 Bucket: {bucket_name}")
            print(f"SNS Topic: {topic_arn}")
            print(f"Lambda Function: {function_arn}")
            print(f"IAM Role: {role_arn}")
            print(f"CloudWatch Logs: {log_group_name}")
            
            print("\n" + "="*60)
            print("NEXT STEPS:")
            print("="*60)
            print("1. If you subscribed an email, confirm the SNS subscription")
            print("2. Test the Lambda function from AWS Console")
            print("3. Check CloudWatch Logs for execution logs")
            print("4. Logs can be exported to S3 for long-term storage")
            
            return {
                'bucket': bucket_name,
                'topic_arn': topic_arn,
                'function_arn': function_arn,
                'role_arn': role_arn,
                'log_group': log_group_name
            }
            
        except Exception as e:
            print(f"\n✗ Deployment failed: {e}")
            raise
    
    def cleanup_infrastructure(self):
        """Clean up all created resources"""
        print("\n" + "="*60)
        print("🧹 CLEANING UP INFRASTRUCTURE")
        print("="*60)
        
        try:
            # Delete Lambda function
            try:
                print(f"\n⚡ Deleting Lambda function: {self.function_name}")
                self.lambda_client.delete_function(FunctionName=self.function_name)
                print(f"✓ Lambda function deleted")
            except Exception as e:
                print(f"⚠ Lambda function not found or already deleted: {e}")
            
            # Delete SNS topic
            try:
                print(f"\n📢 Deleting SNS topic: {self.topic_name}")
                topics = self.sns.list_topics()
                deleted = False
                for topic in topics['Topics']:
                    if self.topic_name in topic['TopicArn']:
                        self.sns.delete_topic(TopicArn=topic['TopicArn'])
                        print(f"✓ SNS topic deleted: {topic['TopicArn']}")
                        deleted = True
                        break
                if not deleted:
                    print(f"⚠ SNS topic not found: {self.topic_name}")
            except Exception as e:
                print(f"⚠ Error deleting SNS topic: {e}")
            
            # Delete S3 buckets with our naming pattern
            try:
                print(f"\n Looking for S3 buckets with pattern 'serverless-logs-*'")
                
                # List all buckets and find matching ones
                buckets = self.s3.list_buckets()
                deleted_count = 0
                
                for bucket in buckets['Buckets']:
                    bucket_name = bucket['Name']
                    if bucket_name.startswith('serverless-logs-'):
                        try:
                            print(f"  Found bucket: {bucket_name}")
                            
                            # Delete all objects
                            print(f"  Deleting objects in {bucket_name}...")
                            paginator = self.s3.get_paginator('list_objects_v2')
                            for page in paginator.paginate(Bucket=bucket_name):
                                if 'Contents' in page:
                                    for obj in page['Contents']:
                                        self.s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
                            
                            # Delete all versions (if versioning enabled)
                            try:
                                versions = self.s3.list_object_versions(Bucket=bucket_name)
                                if 'Versions' in versions:
                                    for version in versions['Versions']:
                                        self.s3.delete_object(
                                            Bucket=bucket_name,
                                            Key=version['Key'],
                                            VersionId=version['VersionId']
                                        )
                                if 'DeleteMarkers' in versions:
                                    for marker in versions['DeleteMarkers']:
                                        self.s3.delete_object(
                                            Bucket=bucket_name,
                                            Key=marker['Key'],
                                            VersionId=marker['VersionId']
                                        )
                            except:
                                pass  # No versions or versioning not enabled
                            
                            # Delete bucket
                            self.s3.delete_bucket(Bucket=bucket_name)
                            print(f"✓ S3 bucket deleted: {bucket_name}")
                            deleted_count += 1
                        except Exception as e:
                            print(f"⚠ Error deleting bucket {bucket_name}: {e}")
                
                if deleted_count == 0:
                    print(f"⚠ No matching S3 buckets found")
                else:
                    print(f"✓ Deleted {deleted_count} S3 bucket(s)")
                    
            except Exception as e:
                print(f"⚠ Error accessing S3 buckets: {e}")
            
            # Detach policies and delete IAM role
            try:
                print(f"\n🔐 Deleting IAM role: {self.role_name}")
                
                # Detach policies
                attached_policies = self.iam.list_attached_role_policies(RoleName=self.role_name)
                for policy in attached_policies['AttachedPolicies']:
                    self.iam.detach_role_policy(
                        RoleName=self.role_name,
                        PolicyArn=policy['PolicyArn']
                    )
                
                # Delete role
                self.iam.delete_role(RoleName=self.role_name)
                print(f"✓ IAM role deleted")
            except Exception as e:
                print(f"⚠ Error deleting IAM role: {e}")
            
            print("\n Cleanup complete!")
            
        except Exception as e:
            print(f"\n✗ Cleanup failed: {e}")


def main():
    """Main function to run infrastructure setup"""
    print("\n" + "="*60)
    print("AWS SERVERLESS INFRASTRUCTURE SETUP")
    print("Lambda + SNS + S3 Logging")
    print("="*60)
    
    # Initialize infrastructure manager
    infra = ServerlessInfrastructure(region='us-east-1')
    
    # Option 1: Deploy infrastructure
    print("\nOptions:")
    print("1. Deploy infrastructure")
    print("2. Cleanup infrastructure")
    print("3. Test existing Lambda function")
    
    choice = input("\nEnter your choice (1-3): ").strip()
    
    if choice == '1':
        # Deploy
        email = input("\nEnter email for SNS notifications (or press Enter to skip): ").strip()
        email = email if email else None
        
        result = infra.deploy_infrastructure(email=email)
        
        print(f"\n Infrastructure details saved!")
        print(f"Region: {infra.region}")
        
    elif choice == '2':
        # Cleanup
        confirm = input("\n Are you sure you want to delete all resources? (yes/no): ").strip()
        if confirm.lower() == 'yes':
            infra.cleanup_infrastructure()
        else:
            print("Cleanup cancelled")
    
    elif choice == '3':
        # Test
        infra.test_lambda_function()
    
    else:
        print("Invalid choice")


if __name__ == "__main__":
    main()
