Lambda Test
----

Example Amazon AWS Lambda function. Triggered by an S3 upload and transforms that upload into many smaller variants.

h1. Credentials

All credentials should be stored locally in the shared credentials file `~/.aws/credentials` in this format:

```
[default]
aws_access_key_id = <YOUR_ACCESS_KEY_ID>
aws_secret_access_key = <YOUR_SECRET_ACCESS_KEY>
```

The AWS node SDK will automatically load it.
