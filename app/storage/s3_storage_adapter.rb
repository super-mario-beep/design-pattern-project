require "aws-sdk-s3"

class S3StorageAdapter < StorageAdapter
  def initialize(bucket:, client: Aws::S3::Client.new)
    @bucket = bucket
    @client = client
  end

  def write(key, io)
    io.rewind if io.respond_to?(:rewind)
    @client.put_object(bucket: @bucket, key: key, body: io)
  end

  def read(key)
    @client.get_object(bucket: @bucket, key: key).body.read
  rescue Aws::S3::Errors::NoSuchKey
    raise FileNotFound, key
  end

  def delete(key)
    @client.delete_object(bucket: @bucket, key: key)
  end

  def exists?(key)
    @client.head_object(bucket: @bucket, key: key)
    true
  rescue Aws::S3::Errors::NotFound
    false
  end
end
