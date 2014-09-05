#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'optparse'
require 'multi_json'
require 'logger'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0}"
  opts.on("--access-id [access_id]", String, "REQUIRED S3 Access ID") { |access_id| options[:access_id] = access_id }
  opts.on("--secret-key [secret_key]", String, "REQUIRED S3 Secret Key") { |secret_key| options[:secret_key] = secret_key }
  opts.on("--bucket [bucket]", String, "REQUIRED S3 Bucket") { |bucket| options[:bucket] = bucket }
  opts.on("--path [path]", String, "REQUIRED S3 Path") { |path| options[:path] = path }
  opts.on("--file [file]", String, "Upload file to S3 object") { |file| options[:file] = file }
  opts.on("--secret", "Upload object with retricted access (Default: false)") { options[:secret] = true }
  opts.on("--copy_from [source_path]", String, "Source path in the same bucket to copy S3 object") { |source| options[:source] = source }
end

begin
  parser.parse!
rescue OptionParser::InvalidOption => e
  puts e.message
  puts parser.help
  exit 0
end

required_options = [:access_id, :secret_key, :bucket, :path]
if !(required_options - options.keys).empty?
  puts parser.help
  exit 0 
end

logger = Logger.new(STDERR)

logger.info "OPTIONS:\n#{MultiJson.dump(options, :pretty => true)}"

s3 = AWS::S3.new(
  :access_key_id     => options[:access_id],
  :secret_access_key => options[:secret_key]
)

begin
  bucket = s3.buckets[options[:bucket]]
  object = bucket.objects[options[:path]]

  if options[:file] && File.exists?(options[:file])
    logger.info "WRITE FROM #{options[:file]} TO #{options[:path]}"
    object.write(File.open(options[:file]), {:acl => (!!options[:secret] ? :private : :public_read)})
  elsif options[:source]
    logger.info "COPY FROM #{options[:source]} TO #{options[:path]}"
    source = bucket.objects[options[:source]]
    object.copy_from(source, {:acl => (!!options[:secret] ? :private : :public_read)})
  end

  puts object.public_url

rescue Exception => e
  logger.info "Could not get URL - #{e.message}"
end
