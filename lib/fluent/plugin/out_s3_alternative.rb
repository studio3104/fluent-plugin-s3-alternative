require 'fluent/mixin/plaintextformatter'

class Fluent::S3AlternativeOutput < Fluent::TimeSlicedOutput
  Fluent::Plugin.register_output('s3_alternative', self)
  include Fluent::Mixin::PlainTextFormatter

  config_param :path, :string, :default => ""

  include Fluent::SetTagKeyMixin
  config_set_default :include_tag_key, false
  include Fluent::SetTimeKeyMixin
  config_set_default :include_time_key, false

  config_param :aws_key_id, :string,  :default => nil
  config_param :aws_sec_key, :string, :default => nil
  config_param :s3_bucket, :string,   :default => nil
  config_param :s3_endpoint, :string, :default => nil
  config_param :s3_object_key_format, :string, :default => "%{path}%{time_slice}_%{index}.%{file_extension}"

  def initialize
    super
    require 'aws-sdk'
    require 'zlib'
    require 'tempfile'
    @use_ssl = true
  end

  def configure(conf)
    if conf['path']
      if conf['path'].index('%S')
        conf['time_slice_format'] = '%Y%m%d%H%M%S'
      elsif conf['path'].index('%M')
        conf['time_slice_format'] = '%Y%m%d%H%M'
      elsif conf['path'].index('%H')
        conf['time_slice_format'] = '%Y%m%d%H'
      end
    end
    
    super

    if use_ssl = conf['use_ssl']
      if use_ssl.empty?
        @use_ssl = true
      else
        @use_ssl = Config.bool_value(use_ssl)
        if @use_ssl.nil?
          raise ConfigError, "'true' or 'false' is required for use_ssl option on s3 output"
        end
      end
    end
  end

  def start
    super
    options = {}
    if @aws_key_id && @aws_sec_key
      options[:access_key_id] = @aws_key_id
      options[:secret_access_key] = @aws_sec_key
    end
    options[:s3_endpoint] = @s3_endpoint if @s3_endpoint

    @s3 = AWS::S3.new(options)
    @bucket = @s3.buckets[@s3_bucket]
  end

  def write(chunk)
    i = 0
    begin
      values_for_s3_object_key = {
        "path" => @path,
        "time_slice" => chunk.key,
        "file_extension" => "gz",
        "index" => i
      }
      s3path = @s3_object_key_format.gsub(%r(%{[^}]+})) { |expr|
        values_for_s3_object_key[expr[2...expr.size-1]]
      }
      i += 1
    end while @bucket.objects[s3path].exists?

    tmp = Tempfile.new("s3-")
    w = Zlib::GzipWriter.new(tmp)
    begin
      chunk.write_to(w)
      w.close
      @bucket.objects[s3path].write(Pathname.new(tmp.path), :content_type => 'application/x-gzip')
    ensure
      w.close rescue nil
    end
  end
end
