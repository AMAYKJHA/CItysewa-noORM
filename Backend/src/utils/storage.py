import os
from pathlib import Path
import uuid


from django.conf import settings

import boto3
from botocore.client import Config


class Storage:
    def __init__(self):
        self.available_buckets = {
            "provider": settings.SUPABASE_S3_PROVIDER_BUCKET_NAME,
            "customer": settings.SUPABASE_S3_CUSTOMER_BUCKET_NAME,
        }

    def get_s3_client(self):
        try:
            s3 = boto3.client(
                "s3",
                aws_access_key_id = settings.SUPABASE_S3_ACCESS_KEY_ID,
                aws_secret_access_key = settings.SUPABASE_S3_SECRET_ACCESS_KEY,
                region_name = settings.SUPABASE_S3_REGION_NAME,
                endpoint_url = settings.SUPABASE_S3_ENDPOINT_URL,
                config = Config(
                    signature_version = "s3v4",
                    s3 = {"addressing_style": "path"}
                )
            )
            return s3
        except Exception as e:
            print(f"Error: {e}")
    
    
    def upload_file(self, bucket=None, folder=None, file=None):
        if folder is None or file is None:
            raise ValueError("Both folder and file_name must be provided.")
        
        
        
        if bucket not in self.available_buckets:
            raise ValueError(f"Bucket: {bucket} doesn`t exists.")
        
        s3 = self.get_s3_client()
        
        file_ext = file.name.split('.')[-1]
        file_name = uuid.uuid4()
        object_key = f"{folder}/{file_name}.{file_ext}"
        try:
            s3.upload_fileobj(
                Fileobj = file,
                Bucket = self.available_buckets.get(bucket),
                Key = object_key,
                ExtraArgs={
                    "ContentType": file.content_type
                }
            )
            return f"{file_name}.{file_ext}"
        except Exception as e:
            print(f"Error: {e}")
            return
    
    def delete_file(self, bucket, folder, file_name):
        s3 = self.get_s3_client()
        try:
            object_key = f"{folder}/{file_name}"
            s3.delete_object(
                Bucket = self.available_buckets.get(bucket),
                Key = object_key
            )
        except Exception as e:
            print(f"Error: {e}")