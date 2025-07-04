from os import environ

import boto3
from flask import Flask

app = Flask(__name__)

AWS_REGION = environ["AWS_REGION"]
S3_BUCKET_NAME = environ["S3_BUCKET_NAME"]
IMAGE_KEY = "example.jpg"
S3_CLIENT = boto3.client("s3", region_name=AWS_REGION)


@app.route("/")
def hello_world():
    image_url = S3_CLIENT.generate_presigned_url(
        "get_object",
        Params={"Bucket": S3_BUCKET_NAME, "Key": IMAGE_KEY},
        ExpiresIn=3600
    )

    return f"""
    <p>Hello, World!</p>
    <img src="{image_url}" alt="S3 Image" style="max-width:100%; height:auto;">
    """


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)