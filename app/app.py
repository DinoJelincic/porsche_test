# from os import environ

# import boto3
# from flask import Flask

# app = Flask(__name__)

# AWS_REGION = environ["AWS_REGION"]
# S3_BUCKET_NAME = environ["S3_BUCKET_NAME"]
# IMAGE_KEY = "example.jpg"
# S3_CLIENT = boto3.client("s3", region_name=AWS_REGION)


# @app.route("/")
# def hello_world():
#     image_url = S3_CLIENT.generate_presigned_url(
#         "get_object",
#         Params={"Bucket": S3_BUCKET_NAME, "Key": IMAGE_KEY},
#         ExpiresIn=3600  # URL expiration time in seconds
#     )

#     return f"""
#     <p>Hello, World!</p>
#     <img src="{image_url}" alt="S3 Image" style="max-width:100%; height:auto;">
#     """


# if __name__ == "__main__":
#     app.run(debug=True, host="0.0.0.0", port=5000)

from os import environ
import boto3
from flask import Flask, request
from datetime import datetime
import logging
import botocore.exceptions

app = Flask(__name__)

AWS_REGION = environ.get("AWS_REGION")
S3_BUCKET_NAME = environ.get("S3_BUCKET_NAME")
IMAGE_KEY = "example.jpg"

S3_CLIENT = boto3.client("s3", region_name=AWS_REGION)

@app.route("/")
def hello_world():
    # IP log
    client_ip = request.headers.get("X-Forwarded-For", request.remote_addr)
    timestamp = datetime.utcnow().isoformat()
    log_line = f"{timestamp} - IP: {client_ip}\n"
    log_key = f"logs/{datetime.utcnow().strftime('%Y-%m-%d')}.log"

    try:
        # Try to get existing log
        try:
            response = S3_CLIENT.get_object(Bucket=S3_BUCKET_NAME, Key=log_key)
            existing = response["Body"].read().decode("utf-8")
        except botocore.exceptions.ClientError as e:
            if e.response["Error"]["Code"] == "NoSuchKey":
                existing = ""
            else:
                raise  # Re-raise other errors

        new_content = existing + log_line

        S3_CLIENT.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=log_key,
            Body=new_content.encode("utf-8"),
            ContentType="text/plain"
        )
    except Exception as e:
        logging.exception("Failed to write log to S3")

    # Image URL
    try:
        image_url = S3_CLIENT.generate_presigned_url(
            "get_object",
            Params={"Bucket": S3_BUCKET_NAME, "Key": IMAGE_KEY},
            ExpiresIn=3600
        )
    except Exception as e:
        logging.exception("Failed to generate presigned URL")
        image_url = ""

    return f"""
    <p>Hello, World!</p>
    <p>Your IP is: {client_ip}</p>
    <img src="{image_url}" alt="S3 Image" style="max-width:100%; height:auto;">
    """
