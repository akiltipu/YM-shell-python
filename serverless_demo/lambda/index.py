"""
Simple Serverless Lambda Function
Sends notifications through AWS SNS
"""

import json
import boto3
import os
from datetime import datetime

# Initialize AWS SNS client
sns = boto3.client('sns')

def lambda_handler(event, context):
    """
    Main Lambda function handler
    This function is triggered by AWS Lambda and sends an SNS notification
    
    Args:
        event: Event data passed to the function
        context: Runtime information
    
    Returns:
        Response with status code and message
    """
    
    try:
        # Get SNS Topic ARN from environment variable
        topic_arn = os.environ.get('SNS_TOPIC_ARN')
        
        if not topic_arn:
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': 'SNS_TOPIC_ARN environment variable not set'
                })
            }
        
        # Prepare notification message
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        # Extract message from event or use default
        if 'body' in event:
            body = json.loads(event['body']) if isinstance(event['body'], str) else event['body']
            message = body.get('message', 'Hello from Lambda!')
            subject = body.get('subject', 'Lambda Notification')
        else:
            message = event.get('message', 'Hello from Lambda!')
            subject = event.get('subject', 'Lambda Notification')
        
        # Create detailed notification message
        notification_message = f"""
Lambda Notification
==================
Time: {timestamp}
Message: {message}

Event Details:
{json.dumps(event, indent=2)}
        """
        
        # Send SNS notification
        response = sns.publish(
            TopicArn=topic_arn,
            Subject=subject,
            Message=notification_message
        )
        
        # Log success
        print(f"SNS notification sent successfully. MessageId: {response['MessageId']}")
        
        # Return success response
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Notification sent successfully',
                'messageId': response['MessageId'],
                'timestamp': timestamp
            })
        }
        
    except Exception as e:
        # Log error
        print(f"Error sending notification: {str(e)}")
        
        # Return error response
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'message': 'Failed to send notification'
            })
        }
