import boto3
import logging
import os

# Initialize the S3 client
s3 = boto3.client('s3')

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Prefix and S3 value
bucket_name = os.environ.get('BUCKET_NAME', 'my-bucket')
input_prefix = os.environ.get('INPUT_PREFIX', 'original/')
output_prefix = os.environ.get('OUTPUT_PREFIX', 'reversed/')

def lambda_handler(event, context):
        
    try:
        object_key = event['Records'][0]['s3']['object']['key']
        
        # Check if the uploaded file is in the 'original/' prefix
        if not object_key.startswith(input_prefix):
            print(f"Skipping file: {object_key}, not in {input_prefix} prefix.")
            return {"status": "skipped"}

        logger.info(f"Processing file {object_key} from bucket {bucket_name}")

        # Extract the base file name (without the input prefix)
        file_name = os.path.basename(object_key)
        base_name, ext = os.path.splitext(file_name)

        # Retrieve the object from S3
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        
        # Read and decode the file content
        original_content = response['Body'].read().decode('utf-8')
        logger.info(f"Original content of {object_key}: {original_content}")
        
        # Reverse the content
        reversed_content = original_content[::-1]
        logger.info(f"Reversed content: {reversed_content}")
        
        # Define the new file name and path for the reversed content
        new_file_name = f"{base_name}_reversed{ext}"
        new_object_key = f"{output_prefix}{new_file_name}"
        
        logger.info(f"Path to reserved content: {new_object_key}")

        # Upload the reversed content to S3
        s3.put_object(
            Bucket=bucket_name,
            Key=new_object_key,
            Body=reversed_content.encode('utf-8')
        )
        
        return {
            'statusCode': 200,
            'body': f"File {new_file_name} uploaded successfully to bucket {bucket_name}"
        }
    
    except Exception as e:
        logger.error(f"Error processing file: {e}", exc_info=True)
        raise
    finally:
        print("...Ending the function")
