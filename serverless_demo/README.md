# Serverless Demo - AWS Lambda + SNS + S3

A beginner-friendly serverless application that sends notifications through AWS SNS with CloudWatch logs saved to S3.

## 📁 Project Structure

```
serverless_demo/
├── lambda/
│   └── index.py          # Lambda function code (sends SNS notifications)
├── infra.py              # Infrastructure setup script (boto3)
└── README.md             # This file
```

## 🚀 Features

- **Lambda Function**: Sends notifications through AWS SNS
- **SNS Topic**: Manages notification subscriptions (email, SMS, etc.)
- **S3 Bucket**: Stores Lambda execution logs
- **CloudWatch Logs**: Automatic logging of Lambda executions
- **IAM Roles**: Proper security setup with least privilege

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** configured with credentials:
   ```bash
   aws configure
   ```
3. **Python 3.9+** installed
4. **Boto3** library:
   ```bash
   pip install boto3
   ```

## 🔧 Setup Instructions

### Step 1: Configure AWS Credentials

```bash
# Configure AWS CLI (if not already done)
aws configure

# Enter your:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Output format (json)
```

### Step 2: Deploy Infrastructure

```bash
# Navigate to the serverless_demo directory
cd serverless_demo

# Run the infrastructure setup script
python infra.py
```

When prompted:
- Choose option `1` to deploy infrastructure
- Enter your email address to receive notifications (optional)
- Confirm your email subscription via the link sent to your inbox

### Step 3: Test the Lambda Function

```bash
# Option 1: Use the infra.py script
python infra.py
# Choose option 3 to test

# Option 2: Test from AWS Console
# - Go to AWS Lambda Console
# - Find the "notification-sender" function
# - Click "Test" and create a test event
```

### Step 4: Check Results

1. **Email**: You should receive a notification email
2. **CloudWatch Logs**: View logs in AWS Console → CloudWatch → Log Groups
3. **S3 Bucket**: Logs can be exported to S3 for long-term storage

## 📝 How It Works

### Lambda Function (lambda/index.py)

```python
# The Lambda function:
1. Receives an event (with optional message/subject)
2. Extracts the SNS topic ARN from environment variables
3. Formats a notification message
4. Sends the notification via SNS
5. Returns success/error response
```

### Infrastructure Script (infra.py)

```python
# The infrastructure script:
1. Creates S3 bucket for logs
2. Creates SNS topic for notifications
3. Subscribes email to SNS (optional)
4. Creates IAM role with necessary permissions
5. Packages Lambda code into zip file
6. Creates/updates Lambda function
7. Tests the Lambda function
8. Provides cleanup functionality
```

## 🧪 Testing

### Test Event Format

```json
{
  "message": "Your custom message here",
  "subject": "Your subject line"
}
```

### Test from Command Line

```bash
# Using AWS CLI
aws lambda invoke \
  --function-name notification-sender \
  --payload '{"message":"Hello from CLI!","subject":"Test"}' \
  response.json

# View response
cat response.json
```

## 🧹 Cleanup

To delete all resources:

```bash
python infra.py
# Choose option 2 to cleanup
# Type "yes" to confirm
```

This will delete:
- Lambda function
- SNS topic
- S3 bucket (and all objects)
- IAM role

## 💡 Customization

### Change Message Format

Edit [lambda/index.py](lambda/index.py):

```python
notification_message = f"""
Your custom format here
Message: {message}
"""
```

### Add More Lambda Triggers

You can add triggers in the AWS Console:
- API Gateway (HTTP endpoint)
- S3 (file upload events)
- EventBridge (scheduled events)
- SQS (queue messages)

### Add Email Recipients

```bash
# Subscribe additional emails
aws sns subscribe \
  --topic-arn YOUR_TOPIC_ARN \
  --protocol email \
  --notification-endpoint your-email@example.com
```

## 🔒 Security Best Practices

1. **IAM Roles**: Use least privilege principle
2. **Environment Variables**: Store sensitive data securely
3. **S3 Bucket**: Enable versioning and encryption
4. **CloudWatch Logs**: Review regularly for errors
5. **Cost Management**: Set up billing alerts

## 📊 Monitoring

### CloudWatch Logs

```bash
# View logs
aws logs tail /aws/lambda/notification-sender --follow

# Export logs to S3 (done automatically by infra.py)
```

### Lambda Metrics

View in AWS Console:
- Invocations
- Duration
- Errors
- Throttles

## 🛠️ Troubleshooting

### Lambda Function Not Sending Notifications

1. Check IAM role has SNS permissions
2. Verify SNS topic ARN is correct
3. Check CloudWatch logs for errors

### Email Not Received

1. Confirm email subscription in SNS
2. Check spam folder
3. Verify email address is correct

### Permission Errors

1. Ensure AWS credentials are configured
2. Check IAM user has necessary permissions
3. Wait for IAM role propagation (10 seconds)

## 📚 Learn More

- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [AWS SNS Documentation](https://docs.aws.amazon.com/sns/)
- [Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

## 💰 Cost Estimation

- **Lambda**: Free tier includes 1M requests/month
- **SNS**: First 1,000 email notifications free
- **S3**: First 5GB storage free
- **CloudWatch Logs**: First 5GB free

**Estimated cost for this demo**: $0 (within free tier)

## 🎯 Next Steps

1. Add API Gateway for HTTP endpoint
2. Implement error handling and retries
3. Add DLQ (Dead Letter Queue) for failed messages
4. Set up Lambda layers for shared code
5. Implement CI/CD pipeline for deployments

## 🤝 Support

For issues or questions:
1. Check AWS CloudWatch logs
2. Review this README
3. Check AWS service status
