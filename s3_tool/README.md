s3_tool
====

Tool written using ruby aws-sdk to perform certain s3 functions.

    Usage: ./s3_tool.rb
        --access-id [access_id]      REQUIRED S3 Access ID
        --secret-key [secret_key]    REQUIRED S3 Secret Key
        --bucket [bucket]            REQUIRED S3 Bucket
        --path [path]                REQUIRED S3 Path
        --file [file]                Upload file to S3 object
        --secret                     Upload object with retricted access (Default: false)
        --copy_from [source_path]    Source path in the same bucket to copy S3 object

Examples

Get public URL for an object in bucket x and key y

    ./s3_url.rb --access-id <foo> --secret-key <bar> --bucket x --path y

Upload local file z to an object in bucket x and key y

    ./s3_url.rb --access-id <foo> --secret-key <bar> --bucket x --path y --file z

In bucket x, copy object from key z to key y

    ./s3_url.rb --access-id <foo> --secret-key <bar> --bucket x --path y --copy_from z

In all cases, the script always writes the public URL of the object to STDOUT

Logs are written to STDERR