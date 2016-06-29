aws describe instances parser
----

Tool to quickly parse output from aws command line tools

Usage:

    aws ec2 describe-instances | aws_describe_instances_parser.rb \
                                   --bastion-username foo \
                                   --ec2-username bar \
                                   --identity-file ~/.ssh/helloworld.pem

