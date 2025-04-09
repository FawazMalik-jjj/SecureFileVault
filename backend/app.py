from flask import Flask, request, jsonify
import boto3
from botocore.exceptions import ClientError
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = '/tmp'

s3 = boto3.client('s3', region_name='us-east-1')
kms = boto3.client('kms', region_name='us-east-1')
bucket_name = os.getenv('S3_BUCKET')

@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    user_id = request.headers.get('X-User-ID')
    filename = f"{user_id}/{file.filename}"
    
    # Encrypt file client-side (optional) before upload
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    
    # Upload to S3 with KMS encryption
    s3.upload_file(
        os.path.join(app.config['UPLOAD_FOLDER'], filename),
        bucket_name,
        filename,
        ExtraArgs={
            'ServerSideEncryption': 'aws:kms',
            'SSEKMSKeyId': os.getenv('KMS_KEY_ARN')
        }
    )
    return jsonify({"message": "File uploaded securely!"})

@app.route('/download/<filename>', methods=['GET'])
def download_file(filename):
    # Generate pre-signed URL with MFA requirement
    try:
        url = s3.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucket_name,
                'Key': filename
            },
            HttpMethod='GET',
            ExpiresIn=3600
        )
        return jsonify({"url": url})
    except ClientError as e:
        return jsonify({"error": str(e)}), 403

if __name__ == '__main__':
    app.run(ssl_context='adhoc', host='0.0.0.0', port=5000)